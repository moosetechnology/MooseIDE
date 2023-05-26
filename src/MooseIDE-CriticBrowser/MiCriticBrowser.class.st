"
I am a MiBrowser used to create rules to apply on the entities of a model. If the entities return true when they are interrogated by the rules (represented through a boolean query), then a violation is created, linking the violating entity and the violated rule.
Allows to export and import the created rules.

- Accepted entities: a MooseObject

- Highlight: None

- Propagate: Violations (by rule or on the whole inputed set of rules)
"
Class {
	#name : #MiCriticBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'entitiesList',
		'runButton',
		'rulesResult',
		'importButton',
		'exportButton',
		'addRulesPresenter',
		'rulesEditorPresenter',
		'rules',
		'expandMenu',
		'addContextsPresenter',
		'contextEditorPresenter'
	],
	#category : #'MooseIDE-CriticBrowser-Browser'
}

{ #category : #'as yet unclassified' }
MiCriticBrowser class >> buildRulesCommandsGroupWith: presenterInstance [

	^ MiAbstractCriticBrowserCommand asCommandGroupWith:
		  presenterInstance
]

{ #category : #'world menu' }
MiCriticBrowser class >> menuCommandOn: aBuilder [

	<worldMenu>
	^ (self buildMenuItemIn: aBuilder) withSeparatorAfter
]

{ #category : #'world menu' }
MiCriticBrowser class >> menuItem [

	^ #MiCrtiticsBrowser
]

{ #category : #'world menu' }
MiCriticBrowser class >> menuPriority [

	^ self menuMainToolsPriority + 7
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

	^ 'Moose Critic Browser'
]

{ #category : #'accessing - testing' }
MiCriticBrowser >> addContextsPresenter [
"used for testing purposes, do not access outside of tests"
	^ addContextsPresenter
]

{ #category : #'accessing - testing' }
MiCriticBrowser >> addRulesPresenter [
"used for testing purposes, do not access outside of tests"
	^ addRulesPresenter
]

{ #category : #accessing }
MiCriticBrowser >> allAvailableContexts [

	^ { specModel rootContext }
	  , (specModel ruleComponents select: [ :component | 
			   component class = FamixCBContext ]) reject: [ :component | 
		  component = rules selectedItem or: [ 
			  rules selectedItem children includes: component ] ]
]

{ #category : #'window control' }
MiCriticBrowser >> browserClosed [
	super browserClosed.
	application unregisterConsumer: addRulesPresenter.
	application unregisterConsumer: rulesEditorPresenter.
	specModel resetResults
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

{ #category : #'as yet unclassified' }
MiCriticBrowser >> childrenForContext: aRuleComponent [

	"content of children block for rules list"

	^ aRuleComponent class = FamixCBCondition
		  ifFalse: [ 
			  aRuleComponent children sorted: [ :a :b | 
				  a printString < b printString ] ]
		  ifTrue: [ {  } ]
]

{ #category : #'accessing - testing' }
MiCriticBrowser >> contextEditorPresenter [
"used for testing purposes, do not access outside of tests"
	^ contextEditorPresenter
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
			addLast: importButton;
			addLast: exportButton;
			spacing: 5; 
			addLast: runButton;
			yourself) expand: false;
	yourself
]

{ #category : #accessing }
MiCriticBrowser >> defaultTitle [
	^ self class title
]

{ #category : #deleting }
MiCriticBrowser >> deleteSelectedRule [
	specModel deleteRuleComponent: rules selectedItem.
	rules roots: { specModel rootContext }.
	self updateResultList: specModel getAllViolations.
	self updateRulesList
]

{ #category : #'updating screen' }
MiCriticBrowser >> displayRule: selectedQuery [
"displays the queries, adding the number of entities they get if the query has been executed"
	^ (specModel violations includesKey: selectedQuery) 
	ifTrue: 
		[ (selectedQuery name), ' (' , ((specModel violationsOf: selectedQuery) size asString) , ')'] 
	ifFalse: [ selectedQuery name ]
]

{ #category : #'accessing - testing' }
MiCriticBrowser >> entitiesList [
"used for testing purposes, do not access outside of tests"
	^ entitiesList
]

{ #category : #'load and saving' }
MiCriticBrowser >> exportRules [
"opens an UI to choose where to save the rules, before opening a stream and saving on the chosen file"
	| fileReference |
	fileReference := UITheme builder
		chooseForSaveFileReference: 'Choose location'
		extensions: { 'ston' }
		path: './pharo-local/rules.ston'.
	fileReference
		ifNotNil: [ fileReference
				writeStreamDo: [ :stream | 
					self exportRulesToStream: stream.
					Notification signal: 'Save successful!' ] ]
]

{ #category : #'load and saving' }
MiCriticBrowser >> exportRulesToStream: aStream [
	specModel ruleComponents do: 
		[ :el | SCExporter export: el onStream: aStream ].
	SCExporter export: specModel createHierarchyTree onStream: aStream
]

{ #category : #actions }
MiCriticBrowser >> followEntity: anEntity [
	self model setEntities: anEntity.
	self updateEntitiesList: specModel entities.
	self updateRulesList.
	self updateResultList: {  }
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
	| reader rulesCollection hierarchy index |
	reader := STONReader on: aStream.
	rulesCollection := OrderedCollection new.
	[ reader atEnd ] whileFalse: [ rulesCollection add: reader parseObject ].
	hierarchy := rulesCollection removeLast.
	reader close.

	(rulesCollection select: [ :rc | rc class = FamixCBCondition ]) do: [ :cond |
		| temp |
		temp := Smalltalk compiler evaluate: cond query.
		(temp class = FullBlockClosure) 
			ifTrue: [ cond query: (MiCriticBrowserPharoCodeQuery on: cond query) ]
			ifFalse: [ cond query: (MiCriticBrowserFQQuery on: temp) ]. 
	].
	(rulesCollection select: [ :rc | rc class = FamixCBContext ]) do: [ :cont |
		cont contextBlock: cont contextBlock.
	].

	index := 1.
	hierarchy do: [ :parentIndex | 
		parentIndex = 0 
			ifTrue: [ specModel addChildToRootContext: (rulesCollection at: index) ]
			ifFalse: [ specModel addChild: (rulesCollection at: index) toContext: (rulesCollection at: parentIndex) ].
		index := index + 1. 
	].
	
]

{ #category : #initialization }
MiCriticBrowser >> initialize [
	super initialize.
	application registerConsumer: addRulesPresenter for: FQAbstractQuery.
	application registerConsumer: rulesEditorPresenter for: FQAbstractQuery
]

{ #category : #initialization }
MiCriticBrowser >> initializeButtons [
	runButton := self newButton.
	importButton := self newButton.
	exportButton := self newButton.
	
	runButton 
		label: 'Run';
		icon: (self iconNamed: #glamorousPlay);
		action: [ self runButtonAction ].
		
	importButton
		label: 'Import rules';
		icon: (self iconNamed: #smallOpen);
		action: [ self importRules ].
	
	exportButton
		label: 'Export rules';
		icon: (self iconNamed: #smallSave);
		action: [ self exportRules ]
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
		items: { self model rootContext };
		display: [ :each | self displayRule: each ];
		displayIcon: [ :each | 
			each class = FamixCBCondition
				ifTrue: [ self iconNamed: #radioButtonOn ]
				ifFalse: [ self iconNamed: #radioButtonSelected ] ];
		children: [ :each | self childrenForContext: each ];
		contextMenu: [ 
			(self class buildRulesCommandsGroupWith: self) asMenuPresenter ];
		beSingleSelection;
		whenSelectionChangedDo: [ 
			specModel violations ifNotEmpty: [ self selectedRules ] ].

	rulesResult
		display: [ :each | self stringForItem: each ];
		displayIcon: [ :each | 
			each class = FamixCBViolation
				ifTrue: [ 
					self iconNamed: each violatedCondition severity iconName ]
				ifFalse: [ self iconNamed: 'blank' ] ];
		children: [ :each | self sortedChildren: each for: rulesResult ];
		contextMenu: expandMenu;
		activateOnDoubleClick;
		whenActivatedDo: [ :each | each selectedItem inspect ]
]

{ #category : #initialization }
MiCriticBrowser >> initializeMenu [

	expandMenu := self newMenu.
	expandMenu
		addItem: [ :item | 
			item
				name: 'Collapse all';
				icon: ((self iconNamed: #windowMenuInactive) rotateBy: -90);
				action: [ rulesResult collapseAll ] ];
		addItem: [ :item | 
			item
				name: 'Expand all';
				icon: ((self iconNamed: #windowMenuInactive) rotateBy: 360);
				action: [ rulesResult expandAll ] ]
]

{ #category : #initialization }
MiCriticBrowser >> initializePresenters [

	super initializePresenters.
	self initializeMenu.
	self initializeLists.
	self initializeButtons.

	addRulesPresenter := MiCriticBrowserAddRulesPresenter on: self.
	rulesEditorPresenter := MiCriticBrowserEditRulePresenter on: self.
	addContextsPresenter := MiCriticBrowserAddContextsPresenter on: self.
	contextEditorPresenter := MiCriticBrowserEditContextPresenter on:
		                          self.

	self focusOrder
		add: rules;
		add: rulesResult;
		add: runButton
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
	^ self rules selectedItem 
		ifNil: [ specModel getAllViolations ] 
		ifNotNil: [ specModel violationsOf: (self rules selectedItem) ]
]

{ #category : #'buttons actions' }
MiCriticBrowser >> moveCurrentRuleComponentToContext: aFamixCBContext [

	| selectedRule |
	selectedRule := rules selectedItem.
	self deleteSelectedRule.

	specModel
		addChild: (selectedRule
				 reset;
				 yourself)
		toContext: aFamixCBContext
]

{ #category : #initialization }
MiCriticBrowser >> openAddConditionDialog [

	addRulesPresenter setParentContext: rules selectedItem.
	^ addRulesPresenter openDialog
]

{ #category : #initialization }
MiCriticBrowser >> openAddContextDialog [

	addContextsPresenter setParentContext: rules selectedItem.
	^ addContextsPresenter openDialog
]

{ #category : #initialization }
MiCriticBrowser >> openEditRuleDialog [

	^ rules selectedItem class = FamixCBCondition
		  ifTrue: [ 
			  rulesEditorPresenter setRuleToEdit: rules selectedItem.
			  rulesEditorPresenter openDialog ]
		  ifFalse: [ 
			  contextEditorPresenter setContextToEdit: rules selectedItem.
			  contextEditorPresenter openDialog ]
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
	self model run.
	self updateResultList: specModel getAllViolations.
	self updateRulesList
]

{ #category : #initialization }
MiCriticBrowser >> runSelectedCondition [

	specModel runCondition: rules selectedItem.
	self updateRulesList.
	^ self updateResultList: specModel getAllViolations
]

{ #category : #'selected object' }
MiCriticBrowser >> selectedRules [
"shows in the output list only the entities validating the selected queries (or the complete output if no query is selected)"
	(rules selectedItem) 
		ifNotNil: [
			self updateResultList: (specModel violationsOf: rules selectedItem).
			self updateEntitiesList: (specModel contextOf: rules selectedItem) asMooseGroup]
		ifNil: [ 
			self updateResultList: specModel getAllViolations.
			self updateEntitiesList: specModel entities ]
]

{ #category : #api }
MiCriticBrowser >> sortedChildren: each for: aTreePresenter [

	"provides content of the children block for the collection root for a given tree presenter"

	^ (self children: each for: aTreePresenter) sorted: [ :a :b | 
		  a printString < b printString ]
]

{ #category : #naming }
MiCriticBrowser >> stringForItem: item [
"returns string to describe an item or a root regrouping entities of the same type"
	(rulesResult roots includes: item) ifTrue: [ ^ item description ].
	^ String streamContents: [ :s | item displayStringOn: s ]
]

{ #category : #'updating screen' }
MiCriticBrowser >> updateEntitiesList: aCollection [
	| roots |
	roots := (aCollection allEntityTypes collect: [ :type | 
		           aCollection allWithType: type ]) asOrderedCollection.
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

	self rules updateRootsKeepingSelection: self rules roots.
	self rules expandAll
]
