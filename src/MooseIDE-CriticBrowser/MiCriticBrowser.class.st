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
		'addRulesPresenter',
		'rulesEditorPresenter',
		'rules',
		'expandMenu',
		'addContextsPresenter',
		'contextEditorPresenter',
		'statusLabel'
	],
	#category : #'MooseIDE-CriticBrowser-Browser'
}

{ #category : #keymaps }
MiCriticBrowser class >> browserKey [

	^ $c
]

{ #category : #commands }
MiCriticBrowser class >> buildActionCommandsGroupWith: presenterInstance [

	^ {
		  (MiCBImportRulesCommand forSpecContext: presenterInstance).
		  (MiCBExportRulesCommand forSpecContext: presenterInstance).
		  (MiCBRunAllRulesCommand forSpecContext: presenterInstance) }
]

{ #category : #commands }
MiCriticBrowser class >> buildRuleCommandsGroupWith: presenterInstance [

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

{ #category : #specs }
MiCriticBrowser class >> windowSize [

	^ 1280 @ 560
]

{ #category : #layout }
MiCriticBrowser >> actionButtonsLayout [

	layout := SpBoxLayout newLeftToRight
		          hAlignEnd;
		          spacing: 5;
		          yourself.

	(self class buildActionCommandsGroupWith: self) do: [ :cmd |
		layout add: cmd asButtonPresenter ].

	^ layout
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
			   component class = FamixCBContext and: [
				   component ~= rules selectedItem and: [
					   (component allParents includes: rules selectedItem) not ] ] ])
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

{ #category : #api }
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
								     add: 'Entities requested' asPresenter expand: false;
								     add: rulesResult;
								     yourself);
						    yourself);
				   yourself);
		  add: (SpBoxLayout newLeftToRight
				   add: statusLabel;
				   add: self actionButtonsLayout;
				   vAlignCenter;
				   yourself)
		  expand: false;
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
	super followEntity: anEntity .
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
	[ reader atEnd ] whileFalse: [
		rulesCollection add: reader parseObject ].
	hierarchy := rulesCollection removeLast.
	reader close.

	(rulesCollection select: [ :rc | rc class = FamixCBCondition ]) do: [
		:cond |
		| temp |
		temp := Smalltalk compiler evaluate: cond query.
		temp class = FullBlockClosure
			ifTrue: [ cond query: (FamixCBQueryHandler on: cond query) ]
			ifFalse: [
				temp isScriptQuery 
					ifTrue: [
						| query |
						query := FamixCBScriptQueryHandler new
							         innerQuery: (FQSelectScriptQuery script: temp script);
							         yourself.
						cond query: query ]
					ifFalse: [ cond query: (FamixCBQueryHandler on: temp) ] ] ].
	(rulesCollection select: [ :rc | rc class = FamixCBContext ]) do: [
		:cont | cont contextBlock: cont contextBlock ].

	index := 1.
	hierarchy do: [ :parentIndex |
		parentIndex = 0
			ifTrue: [
			specModel addChildToRootContext: (rulesCollection at: index) ]
			ifFalse: [
				specModel
					addChild: (rulesCollection at: index)
					toContext: (rulesCollection at: parentIndex) ].
		index := index + 1 ]
]

{ #category : #initialization }
MiCriticBrowser >> initialize [

	super initialize.
	application registerConsumer: addRulesPresenter for: FQAbstractQuery.
	application
		registerConsumer: rulesEditorPresenter
		for: FQAbstractQuery
]

{ #category : #initialization }
MiCriticBrowser >> initializeLists [

	entitiesList := self newMooseGroupsTreeTable.

	rules := self newTree.
	rules
		items: { self model rootContext };
		display: [ :each | self displayRule: each ];
		displayIcon: [ :each |
			each class = FamixCBCondition
				ifTrue: [ self iconNamed: #radioButtonOn ]
				ifFalse: [ self iconNamed: #radioButtonSelected ] ];
		children: [ :each | self childrenForContext: each ];
		contextMenu: [
			(self class buildRuleCommandsGroupWith: self) asMenuPresenter ];
		beSingleSelection;
		whenSelectionChangedDo: [
			specModel violations ifNotEmpty: [ self selectedRules ] ].

	rulesResult := self newMooseGroupsTreeTable
		               displayIcon: #mooseIcon;
		               childrenSortingBlock:
			               #severityLevel descending , #displayString ascending;
		               manageNodesFromMenu;
		               yourself
]

{ #category : #initialization }
MiCriticBrowser >> initializePresenters [

	super initializePresenters.

	self initializeLists.
	self initializeStatusLabel.

	addRulesPresenter := MiCBAddRulesPresenter on: self.
	rulesEditorPresenter := MiCBEditRulePresenter on: self.
	addContextsPresenter := MiCBAddContextsPresenter on: self.
	contextEditorPresenter := MiCBEditContextPresenter on: self.

	self focusOrder
		add: rules;
		add: rulesResult;
		add: runButton
]

{ #category : #initialization }
MiCriticBrowser >> initializeStatusLabel [

	statusLabel := self newLabel.
	self updateStatusLabel: 'Critic Browser is ready to work!'
]

{ #category : #accessing }
MiCriticBrowser >> miSelectedItem [

	^ self rules selectedItem
		  ifNil: [ specModel getAllViolations ]
		  ifNotNil: [ specModel violationsOf: self rules selectedItem ]
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

{ #category : #'buttons actions' }
MiCriticBrowser >> runAllRules [
	"Executes the queries on the entities stored in the model, then prints the results"

	self model run.

	[
	self model run.
	self updateStatusLabel: 'Updating display...'.
	self updateResultList: specModel getAllViolations.
	self updateRulesList.
	self updateStatusLabel: 'Critics finished.' ] fork
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
	^ item displayString
]

{ #category : #initialization }
MiCriticBrowser >> tagRuleResult [

	rules selectedItem tagRuleResult. 

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
	entitiesList refresh
]

{ #category : #'updating screen' }
MiCriticBrowser >> updateResultList: aCollection [

	| roots |
	aCollection
		ifNotEmpty: [
			roots := (aCollection allViolatingEntitiesType collect: [ :type |
				          aCollection allWithViolatingEntitiesType: type ])
				         asOrderedCollection.
			roots do: [ :group |
				group description: group stringForCBDescription ].
			rulesResult roots:
				(roots sort: [ :group | group description onlyLetters ] ascending).
			rulesResult refresh ]
		ifEmpty: [
			roots := aCollection.
			rulesResult roots: roots ].

	self updateToolbar.
	rulesResult expandAll
]

{ #category : #'updating screen' }
MiCriticBrowser >> updateRulesList [

	self rules updateRootsKeepingSelection: self rules roots.
	self rules expandAll
]

{ #category : #'buttons actions' }
MiCriticBrowser >> updateStatusLabel: aString [

	statusLabel label: DateAndTime now asStringYMDHM , ': ' , aString
]
