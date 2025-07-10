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
		'rulesResult',
		'rules',
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

{ #category : #initialization }
MiCriticBrowser class >> childrenForContext: aRuleComponent [
	"Content of children block for rules list"

	^ aRuleComponent isCBCondition
		  ifFalse: [ aRuleComponent children sorted: #printString ascending ]
		  ifTrue: [ {  } ]
]

{ #category : #initialization }
MiCriticBrowser class >> iconForRuleComponent: aRuleComponent [

	^ aRuleComponent isCBCondition
		  ifTrue: [ self iconNamed: #radioButtonOn ]
		  ifFalse: [ self iconNamed: #radioButtonSelected ]
]

{ #category : #'world menu' }
MiCriticBrowser class >> menuCommandOn: aBuilder [

	<worldMenu>
	<miBrowsersMenu>
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
MiCriticBrowser class >> preferredExtent [

	^ 1280 @ 560
]

{ #category : #specs }
MiCriticBrowser class >> title [

	^ 'Moose Critic Browser'
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

{ #category : #'window control' }
MiCriticBrowser >> browserClosed [

	super browserClosed.
	specModel resetResults
]

{ #category : #testing }
MiCriticBrowser >> canFollowEntity: anEntity [

	^ anEntity isMooseObject
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

{ #category : #deleting }
MiCriticBrowser >> deleteSelectedRule [

	specModel deleteRuleComponent: rules selectedItem.
	rules roots: { specModel rootContext }.
	self updateResultList: specModel getAllViolations.
	self updateRulesList
]

{ #category : #initialization }
MiCriticBrowser >> displayRule: aRuleComponent [

	^ specModel violations
		  at: aRuleComponent
		  ifPresent: [ :violations |
			  aRuleComponent name , ' (' , violations size asString , ')' ]
		  ifAbsent: [ aRuleComponent name ]
]

{ #category : #'import-export' }
MiCriticBrowser >> exportRules [
	"Opens an UI to choose where to save the rules, before opening a stream and saving on the chosen file"

	| fileReference |
	fileReference := UITheme builder
		                 chooseForSaveFileReference: 'Choose location'
		                 extensions: { 'ston' }
		                 path: './pharo-local/rules.ston'.
	fileReference ifNotNil: [
		fileReference writeStreamDo: [ :stream |
			self exportRulesToStream: stream.
			Notification signal: 'Save successful!' ] ]
]

{ #category : #'import-export' }
MiCriticBrowser >> exportRulesToStream: aStream [

	specModel ruleComponents do: [ :el |
		SCExporter export: el onStream: aStream ].
	SCExporter export: specModel createHierarchyTree onStream: aStream
]

{ #category : #actions }
MiCriticBrowser >> followEntity: anEntity [

	super followEntity: anEntity.
	self model setEntities: anEntity.
	self updateEntitiesList: specModel entities.
	self updateRulesList.
	self updateResultList: {  }
]

{ #category : #'import-export' }
MiCriticBrowser >> importRules [
	"Opens an UI to choose what rules file to import, before opening a stream on it and importing the rules"

	| fileReference |
	fileReference := UITheme builder
		                 chooseExistingFileReference:
		                 'Choose rules file to import'
		                 extensions: { 'ston' }
		                 path: './pharo-local'.
	fileReference ifNotNil: [
		fileReference readStreamDo: [ :stream |
			self importRulesFromStream: stream.
			Notification signal: 'Import successful!' ] ].
	self updateRulesList
]

{ #category : #'import-export' }
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
			temp isClosure
				ifTrue: [ cond query: (FamixCBQueryHandler on: cond query) ]
				ifFalse: [
						temp isScriptQuery
							ifTrue: [
									| query |
									query := FamixCBScriptQueryHandler new
										         innerQuery:
											         (FQSelectScriptQuery script: temp script);
										         yourself.
									cond query: query ]
							ifFalse: [ cond query: (FamixCBQueryHandler on: temp) ] ] ].
	(rulesCollection select: [ :rc | rc class = FamixCBContext ]) do: [
		:cont | cont contextFilter: cont contextFilter ].

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
MiCriticBrowser >> initializeLists [

	entitiesList := self newMooseGroupsTreeTable.
	entitiesList whenSelectedItemChangedDo: [ self updateToolbar ].

	rules := self newTree.
	rules
		items: { self model rootContext };
		display: [ :each | self displayRule: each ];
		displayIcon: [ :each | self class iconForRuleComponent: each ];
		children: [ :each | self class childrenForContext: each ];
		contextMenu: [
			(self class buildRuleCommandsGroupWith: self) asMenuPresenter ];
		beSingleSelection;
		whenSelectedItemChangedDo: [ :selectedRule |
			specModel selectedRule: selectedRule ];
		whenSelectionChangedDo: [
			specModel violations ifNotEmpty: [ self showSelectedRuleResult ] ].

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
	self initializeStatusLabel
]

{ #category : #initialization }
MiCriticBrowser >> initializeStatusLabel [

	statusLabel := self newLabel.
	self updateStatusLabel: 'Critic Browser is ready to work!'
]

{ #category : #accessing }
MiCriticBrowser >> miSelectedItem [

	^ (specModel selectedRule
		   ifNil: [ specModel getAllViolations ]
		   ifNotNil: [ :ruleComponent |
		   specModel violationsOf: ruleComponent ]) ifEmpty: [
		  entitiesList miSelectedItem ]
]

{ #category : #actions }
MiCriticBrowser >> moveCurrentRuleComponentToContext: aFamixCBContext [

	| selectedRule |
	selectedRule := specModel selectedRule.
	self deleteSelectedRule.

	specModel
		addChild: (selectedRule
				 reset;
				 yourself)
		toContext: aFamixCBContext
]

{ #category : #actions }
MiCriticBrowser >> openEditRuleComponentDialog [

	^ rules selectedItem class = FamixCBCondition
		  ifTrue: [
			  (MiCBConditionBuilderPresenter on: specModel)
				  beForEdition;
				  openDialog ]
		  ifFalse: [
			  (MiCBContextBuilderPresenter on: specModel)
				  beForEdition;
				  openDialog ]
]

{ #category : #actions }
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

{ #category : #actions }
MiCriticBrowser >> runSelectedCondition [

	specModel runCondition: rules selectedItem.
	self updateRulesList.
	^ self updateResultList: specModel getAllViolations
]

{ #category : #accessing }
MiCriticBrowser >> selectedRule [

	^ specModel selectedRule
]

{ #category : #actions }
MiCriticBrowser >> showSelectedRuleResult [
	"Shows in the output list only the entities validating the selected queries (or the complete output if no query is selected)"

	rules selectedItem
		ifNotNil: [
			self updateResultList: (specModel violationsOf: rules selectedItem).
			self updateEntitiesList:
				(specModel contextOf: rules selectedItem) asMooseGroup ]
		ifNil: [
			self updateResultList: specModel getAllViolations.
			self updateEntitiesList: specModel entities ]
]

{ #category : #actions }
MiCriticBrowser >> tagRuleResult [

	rules selectedItem tagRuleResult. 

]

{ #category : #updating }
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

{ #category : #updating }
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

{ #category : #updating }
MiCriticBrowser >> updateRulesList [

	rules updateRootsKeepingSelection: rules roots.
	rules expandAll
]

{ #category : #actions }
MiCriticBrowser >> updateStatusLabel: aString [

	statusLabel label: DateAndTime now asStringYMDHM , ': ' , aString
]
