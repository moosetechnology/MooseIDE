"
Class implementing the presenter used to input queries, can use Pharo code or queries produced by the Queries Browser.
"
Class {
	#name : #MiCBConditionBuilderPresenter,
	#superclass : #MiPresenter,
	#instVars : [
		'codeButton',
		'queriesBrowserButton',
		'codeInput',
		'queryDroplist',
		'changeableBlock',
		'severityDroplist',
		'conditionTitle',
		'conditionSummary',
		'usePharoCode',
		'browserModel',
		'selectedRuleComponent',
		'isForEdition'
	],
	#category : #'MooseIDE-CriticBrowser-Presenters'
}

{ #category : #api }
MiCBConditionBuilderPresenter class >> initialExtent [

	^ 600 @ 400
]

{ #category : #specs }
MiCBConditionBuilderPresenter class >> title [

	^ 'Rules builder'
]

{ #category : #initialization }
MiCBConditionBuilderPresenter >> actionButton [

	^ isForEdition
		  ifFalse: [
			  self newButton
				  label: 'Add condition';
				  iconName: #smallAdd;
				  action: [
					  self addNewCondition.
					  self withWindowDo: #close ];
				  yourself ]
		  ifTrue: [
			  self newButton
				  label: 'Confirm';
				  iconName: #glamorousEdit;
				  action: [
					  self editCondition.
					  self withWindowDo: #close ] ]
]

{ #category : #action }
MiCBConditionBuilderPresenter >> addNewCondition [

	codeInput text ifNil: [
		self application alert:
			'Please give your condition a code to execute.' ].

	browserModel
		addChild: (self buildCondition: FamixCBCondition new)
		toContext: selectedRuleComponent
]

{ #category : #initialization }
MiCBConditionBuilderPresenter >> beForEdition [

	self fillWithCondition: selectedRuleComponent.
	isForEdition := true
]

{ #category : #action }
MiCBConditionBuilderPresenter >> buildCondition: aCondition [

	aCondition name: conditionTitle text.

	aCondition query: (usePharoCode
			 ifTrue: [ FamixCBScriptQueryHandler on: codeInput text ]
			 ifFalse: [ FamixCBQueryHandler on: queryDroplist selectedItem ]).

	aCondition summary: conditionSummary text.

	aCondition severity: severityDroplist selectedItem.

	^ aCondition
]

{ #category : #layout }
MiCBConditionBuilderPresenter >> choiceLayout [

	^ self newBoxLayoutLeftToRight
		  add: codeButton;
		  add: queriesBrowserButton;
		  beHomogeneous;
		  yourself
]

{ #category : #layout }
MiCBConditionBuilderPresenter >> conditionComputingLayout [

	| conditionComputingLayout |
	conditionComputingLayout := self newBoxLayoutTopToBottom.

	usePharoCode
		ifTrue: [
			conditionComputingLayout
				add: 'Compute condition:' expand: false;
				add: codeInput ]
		ifFalse: [
			conditionComputingLayout
				add: 'Select a query:';
				add: queryDroplist ].

	^ conditionComputingLayout
]

{ #category : #layout }
MiCBConditionBuilderPresenter >> defaultLayout [

	^ self newBoxLayoutTopToBottom
		  spacing: 10;
		  add: self titleAndSeverityLayout height: 75;
		  add: self choiceLayout expand: false;
		  add: self conditionComputingLayout;
		  add: self summaryLayout;
		  yourself
]

{ #category : #action }
MiCBConditionBuilderPresenter >> editCondition [

	self buildCondition: selectedRuleComponent.

	browserModel hasBeenEdited: selectedRuleComponent
]

{ #category : #initialization }
MiCBConditionBuilderPresenter >> fillWithCondition: aCondition [

	conditionTitle text: aCondition name.

	aCondition severity ifNotNil: [
		severityDroplist selectItem: aCondition severity ].

	codeInput text: aCondition query asRuleEditorString.

	conditionSummary text: (aCondition summary ifNil: [ '' ])
]

{ #category : #initialization }
MiCBConditionBuilderPresenter >> initialize [

	super initialize.
	usePharoCode := true.
	isForEdition := false.
	self application registerConsumer: self for: FQAbstractQuery
]

{ #category : #initialization }
MiCBConditionBuilderPresenter >> initializeChoiceButtons [

	codeButton := self newRadioButton
		              label: 'Use Pharo code';
		              whenActivatedDo: [ self usePharoCode ];
		              yourself.

	queriesBrowserButton := self newRadioButton
		                        label: 'Use a query';
		                        whenActivatedDo: [ self useQuery ];
		                        yourself.

	codeButton associatedRadioButtons: { queriesBrowserButton }
]

{ #category : #initialization }
MiCBConditionBuilderPresenter >> initializeDialogWindow: aDialogWindowPresenter [

	aDialogWindowPresenter
		addButton: self actionButton;
		addButton: (self newButton
				 label: 'Close';
				 iconName: #glamorousClose;
				 action: [ self withWindowDo: #close ];
				 yourself)
]

{ #category : #initialization }
MiCBConditionBuilderPresenter >> initializePresenters [

	self initializeChoiceButtons.

	conditionTitle := self newTextInput.

	severityDroplist := self newDropList
		                    items: FamixCBAbstractSeverity allSubclasses;
		                    display: [ :item | item droplistDisplayString ];
		                    displayIcon: [ :item |
			                    self iconNamed: item iconName ];
		                    sortingBlock:
			                    [ :item | item model level ] ascending.

	codeInput := self newCode
		             text: '[ :entity | entity  ]';
		             yourself.
	codeInput eventHandler whenFocusReceivedDo: [ "Set cursor to the position where some code should be added or modified"
		| pipePosition |
		pipePosition := codeInput text findString: ']'.
		codeInput selectionInterval: (pipePosition - 1 to: pipePosition - 2) ].

	queryDroplist := self newDropList
		                 startWithoutSelection;
		                 items:
			                 ((self application itemsFor: FQAbstractQuery)
				                  asOrderedCollection select: [ :each |
					                  each isValid ]);
		                 centered;
		                 yourself.

	conditionSummary := self newText
]

{ #category : #initialization }
MiCBConditionBuilderPresenter >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter initialExtent: self class initialExtent.
	aWindowPresenter whenClosedDo: [
		self application unregisterConsumer: self ]
]

{ #category : #'accessing - model' }
MiCBConditionBuilderPresenter >> setModelBeforeInitialization: aBrowserModel [

	browserModel := aBrowserModel.
	selectedRuleComponent := browserModel selectedRule
]

{ #category : #layout }
MiCBConditionBuilderPresenter >> summaryLayout [

	^ self newBoxLayoutTopToBottom
		  spacing: 5;
		  add: 'Condition summary:' expand: false;
		  add: conditionSummary;
		  yourself
]

{ #category : #layout }
MiCBConditionBuilderPresenter >> titleAndSeverityLayout [

	^ self newGridLayout
		  beColumnNotHomogeneous;
		  column: 2 expand: true;
		  build: [ :builder |
			  builder
				  add: 'Condition name:';
				  add: conditionTitle;
				  nextRow;
				  add: 'Severity:';
				  add: severityDroplist;
				  nextRow ];
		  yourself
]

{ #category : #layout }
MiCBConditionBuilderPresenter >> updateLayout [

	self layout: self defaultLayout
]

{ #category : #'computing options' }
MiCBConditionBuilderPresenter >> usePharoCode [

	usePharoCode := true.
	self updateLayout
]

{ #category : #'computing options' }
MiCBConditionBuilderPresenter >> useQuery [

	usePharoCode := false.
	self updateLayout
]
