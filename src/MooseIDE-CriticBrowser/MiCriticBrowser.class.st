"
I am a MiBrowser used to create rules to apply on the entities of a model. If the entities return true when they are interrogated by the rules (represented through a boolean query), then a violation is created, linking the violating entity and the violated rule.
Allows to export and import the created rules.

- Follow: Accepts MooseObjects

- Highlight: None

- Propagate: Violations (by rule or on the whole inputed set of rules)
"
Class {
	#name : #MiCriticBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'entitiesList',
		'editMenu',
		'runButton',
		'rulesResult',
		'inspectButton',
		'importButton',
		'exportButton',
		'addRulesPresenter',
		'rulesEditorPresenter',
		'openRulesMakerButton',
		'rules',
		'expandMenu'
	],
	#category : #'MooseIDE-CriticBrowser'
}

{ #category : #'world menu' }
MiCriticBrowser class >> menuCommandOn: aBuilder [

	<worldMenu>
	<miBrowsers>
	(aBuilder item: #SpecializedBrowser)
		parent: self midasBrowserMenuLabel;
		label: self title;
		icon: (self iconNamed: self menuIconName);
		help: self helpMessage;
		action: [ self open ]
]

{ #category : #'instance creation' }
MiCriticBrowser class >> newModel [
	^ MiCriticBrowserModel new
]

{ #category : #'instance creation' }
MiCriticBrowser class >> open [
	<script>
	^ super open
]

{ #category : #specs }
MiCriticBrowser class >> title [ 
	^ 'Model Critic Browser'
]

{ #category : #'accessing - testing' }
MiCriticBrowser >> addRulesPresenter [
"used for testing purposes, do not access outside of tests"
	^ addRulesPresenter
]

{ #category : #'window control' }
MiCriticBrowser >> browserClosed [
	super browserClosed.
	application unregisterConsumer: addRulesPresenter.
	application unregisterConsumer: rulesEditorPresenter
]

{ #category : #testing }
MiCriticBrowser >> canFollowEntity: anEntity [
"whether the browser accepts to deal with anObject"
	^ anEntity isMooseObject
]

{ #category : #api }
MiCriticBrowser >> children: aCollection for: aTreePresenter [
"provides content of the children block for the collection root for a given tree presenter"
	^ (aTreePresenter roots includes: aCollection) 
		ifTrue: [ (aTreePresenter roots at: (aTreePresenter roots indexOf: aCollection)) asCollection ] 
		ifFalse: [ {  } ]
]

{ #category : #layout }
MiCriticBrowser >> defaultLayout [	
	^ SpBoxLayout newTopToBottom
		add: (SpPanedLayout newLeftToRight
			add: (SpBoxLayout new 
					add: 'Entities' expand: false;
					add: entitiesList;
					yourself);
			add: (SpPanedLayout newLeftToRight
				add: (SpBoxLayout new 
					add: 'Rules' expand: false;
					add: rules;
					yourself);
				add: (SpBoxLayout new 
					add: ('Entities requested' asPresenter) expand: false;
					add: rulesResult;
					yourself);
			yourself);
		yourself);
		add: (SpBoxLayout newLeftToRight
			add: inspectButton expand: false;
			addLast: importButton;
			addLast: exportButton;
			addLast: openRulesMakerButton;
			spacing: 5; 
			addLast: runButton;
			yourself) expand: false;
	yourself
]

{ #category : #accessing }
MiCriticBrowser >> defaultTitle [
	^ 'Model Critic Browser'
]

{ #category : #deleting }
MiCriticBrowser >> deleteSelectedRule [
	rules selectedItems do: [ :rule | model deleteRule: rule ] 
]

{ #category : #'updating screen' }
MiCriticBrowser >> displayRule: selectedQuery [
"displays the queries, adding the number of entities they get if the query has been executed"
	^ (model violations includesKey: selectedQuery) 
	ifTrue: 
		[ (selectedQuery name), ' (' , ((model violationsOf: selectedQuery) size asString) , ')'] 
	ifFalse: [ selectedQuery name ]
]

{ #category : #'accessing - testing' }
MiCriticBrowser >> entitiesList [
"used for testing purposes, do not access outside of tests"
	^ entitiesList
]

{ #category : #'load and saving' }
MiCriticBrowser >> exportRules: aCollectionOfRules [
"opens an UI to choose where to save the rules, before opening a stream and saving on the chosen file"
	| fileReference |
	fileReference := UITheme builder
		chooseForSaveFileReference: 'Choose location'
		extensions: { 'ston' }
		path: './pharo-local/rules.ston'.
	fileReference
		ifNotNil: [ fileReference
				writeStreamDo: [ :stream | 
					self exportRules: aCollectionOfRules toStream: stream.
					Notification signal: 'Save successful!' ] ]
]

{ #category : #'load and saving' }
MiCriticBrowser >> exportRules: aCollectionOfRules toStream: aStream [
	aCollectionOfRules do: [ :rule | SCExporter export: rule onStream: aStream ]
]

{ #category : #actions }
MiCriticBrowser >> followEntity: anEntity [
	self model setEntities: (anEntity asMooseGroup).
	self updateEntitiesList 
]

{ #category : #'load and saving' }
MiCriticBrowser >> importRules [
"opens an UI to choose what rules file to import, before opening a stream on it and importing the rules"
	| fileReference |
	fileReference := UITheme builder
		chooseExistingFileReference: 'Choose rules file to import'
		extensions: { 'ston' }
		path: './pharo-local'.
	fileReference
		ifNotNil: [ fileReference
				readStreamDo: [ :stream | 
					self importRulesFromStream: stream.
					Notification signal: 'Import successful!' ] ].
	self updateRulesList
]

{ #category : #'load and saving' }
MiCriticBrowser >> importRulesFromStream: aStream [
"import rules from a ston rules file opened on a stream"
	| reader rulesCollection |
	reader := STONReader on: aStream.
	rulesCollection := OrderedCollection new.
	[ reader atEnd ] whileFalse: [ rulesCollection add: reader parseObject ].
	rulesCollection do: [ :rule | 
		| temp | 
		temp := Smalltalk compiler evaluate: rule query.
		(temp class = FullBlockClosure) 
			ifTrue: [ rule query: (MiCriticBrowserPharoCodeQuery on: rule query) ]
			ifFalse: [ rule query: (MiCriticBrowserFQQuery on: temp) ].
		model addRule: rule
	].
	reader close
	
]

{ #category : #initialization }
MiCriticBrowser >> initialize [
	super initialize.
	application registerConsumer: addRulesPresenter for: FQAbstractQuery.
	application registerConsumer: rulesEditorPresenter for: FQAbstractQuery
]

{ #category : #initialization }
MiCriticBrowser >> initializeButtons [
	inspectButton := self newButton.
	openRulesMakerButton := self newButton.
	runButton := self newButton.
	importButton := self newButton.
	exportButton := self newButton.
	
	openRulesMakerButton
		label: 'Add rules';
		icon: (self iconNamed: #smallAdd);
		action: [ addRulesPresenter openDialog ].
	
	runButton 
		label: 'Run';
		icon: (self iconNamed: #glamorousPlay);
		action: [ self runButtonAction ].
	
	inspectButton 
		label: 'Inspect model';
		icon: (self iconNamed: #glamorousInspect);
		action: [ self model entities inspect ].
		
	importButton
		label: 'Import rules';
		icon: (self iconNamed: #smallOpen);
		action: [ self importRules ].
	
	exportButton
		label: 'Export rules';
		icon: (self iconNamed: #smallSave);
		action: [ self exportRules: model rules ]
]

{ #category : #initialization }
MiCriticBrowser >> initializeLists [
	entitiesList := self newTree.
	rules := self newTree.
	rulesResult := self newTree.
	
	entitiesList 
		display: [ :each | self stringForItem: each ];
		children: [ :each | self children: each for: entitiesList ];
		activateOnDoubleClick;
		whenActivatedDo: [ :each | each selectedItem inspect ].
	
	rules
		items: self model rules;
		display: [ :each | self displayRule: each ];
		contextMenu: editMenu;
		beMultipleSelection;
		whenMultiSelectionChangedDo: [ (model violations) ifNotEmpty: [ self selectedRules ] ].
	
	rulesResult
		display: [ :each | self stringForItem: each ];
		children: [ :each | self children: each for: rulesResult ];
		contextMenu: expandMenu;
		activateOnDoubleClick;
		whenActivatedDo: [ :each | each selectedItem inspect ]
]

{ #category : #initialization }
MiCriticBrowser >> initializeMenu [
	editMenu := self newMenu.
	editMenu addItem: [ :item | 
		item
			name: 'Edit rule';
			icon: (self iconNamed: #glamorousEdit);
			action: [ 
				rulesEditorPresenter setRuleToEdit: rules selectedItem.
				rulesEditorPresenter openDialog
					] ];
				addItem: [ :item | 
		item
			name: 'Delete rule';
			icon: (self iconNamed: #smallDelete);
			action: [ self deleteSelectedRule. self updateRulesList ]
		].
	expandMenu := self newMenu.
	expandMenu addItem: [ :item | 
		item
			name: 'Collapse all';
			icon: ((self iconNamed: #windowMenuInactive) rotateBy: -90);
			action: [ rulesResult collapseAll ]
		];
	addItem: [ :item | 
		item
			name: 'Expand all';
			icon: ((self iconNamed: #windowMenuInactive) rotateBy: 360);
			action: [ rulesResult expandAll ] 
			].
]

{ #category : #initialization }
MiCriticBrowser >> initializePresenters [
	
	super initializePresenters.
	self initializeMenu.
	self initializeLists.
	self initializeButtons.
	
	addRulesPresenter := MiCriticBrowserAddRulesPresenter on: self.
	rulesEditorPresenter := MiCriticBrowserEditRulePresenter on: self.
	
	self focusOrder
			add: rules;
			add: rulesResult;
			add: inspectButton;
			add: openRulesMakerButton;
			add: runButton.
]

{ #category : #initialization }
MiCriticBrowser >> initializeWindow: aWindowPresenter [	
	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		title: self defaultTitle;
		initialExtent: 1280 @ 560
]

{ #category : #accessing }
MiCriticBrowser >> miSelectedItem [ 
	^ self rules selectedItems 
		ifEmpty: [ model getAllViolations ] 
		ifNotEmpty: [ model violationsOfCollection: (self rules selectedItems) ]
]

{ #category : #'accessing - testing' }
MiCriticBrowser >> openRulesMakerButton [
"used for testing purposes, do not access outside of tests"
	^ openRulesMakerButton
]

{ #category : #'accessing - testing' }
MiCriticBrowser >> rules [
"used for testing purposes, do not access outside of tests"
	^ rules
]

{ #category : #'accessing - testing' }
MiCriticBrowser >> rulesEditorPresenter [
"used for testing purposes, do not access outside of tests"
	^ rulesEditorPresenter
]

{ #category : #'accessing - testing' }
MiCriticBrowser >> rulesResult [
"used for testing purposes, do not access outside of tests"
	^ rulesResult 
]

{ #category : #'accessing - testing' }
MiCriticBrowser >> runButton [
"used for testing purposes, do not access outside of tests"
	^ runButton
]

{ #category : #'buttons actions' }
MiCriticBrowser >> runButtonAction [
"executes the queries on the entities stored in the model, then prints the results"
	self model runRules.
	self updateResultList: model getAllViolations.
	self updateRulesList
]

{ #category : #'selected object' }
MiCriticBrowser >> selectedRules [
"shows in the output list only the entities validating the selected queries (or the complete output if no query is selected)"
	(rules selectedItems) 
		ifNotEmpty: [
			self updateResultList: (model violationsOfCollection: (rules selectedItems)) ]
		ifEmpty: [ 
			self updateResultList: model getAllViolations ]
]

{ #category : #naming }
MiCriticBrowser >> stringForItem: item [
"returns string to describe an item or a root regrouping entities of the same type"
	(rulesResult roots includes: item) ifTrue: [ ^ item description ].
	^ item mooseName
]

{ #category : #'updating screen' }
MiCriticBrowser >> updateEntitiesList [
	| roots |
	roots := (model entities allEntityTypes collect: [ :type | 
		           model entities allWithType: type ]) asOrderedCollection.
	roots do: [ :group | group description: group details ].
	entitiesList roots:
		(roots sort: [ :group | group description onlyLetters ] ascending).
	
	entitiesList roots: roots.
	entitiesList refresh.
	
]

{ #category : #'updating screen' }
MiCriticBrowser >> updateResultList: aCollection [
	| roots |
	aCollection ifNotEmpty: [ 
	roots := (aCollection allViolatingEntitiesType collect: [ :type | 
		           aCollection allWithViolatingEntitiesType: type ]) asOrderedCollection.
	roots do: [ :group | group description: group stringForCBDescription ].
	rulesResult roots:
		(roots sort: [ :group | group description onlyLetters ] ascending).
	rulesResult refresh.
	] ifEmpty: [ 
	roots := aCollection.
	rulesResult roots: roots
	].
	self updateToolbar.
	rulesResult expandAll
]

{ #category : #'updating screen' }
MiCriticBrowser >> updateRulesList [
	rules roots: self model rules.
	rules refresh
]
