"
Class implementing the presenter used to input queries, can use Pharo code or queries produced by the Queries Browser.
"
Class {
	#name : #MiCBConditionBuilderPresenter,
	#superclass : #MiCBRuleComponentBuilderPresenter,
	#instVars : [
		'codeButton',
		'queriesBrowserButton',
		'queryDroplist',
		'severityDroplist',
		'usePharoCode'
	],
	#category : #'MooseIDE-CriticBrowser-Presenters'
}

{ #category : #labels }
MiCBConditionBuilderPresenter class >> defaultCodeInput [

	^ '[ :entity | entity  ]'
]

{ #category : #labels }
MiCBConditionBuilderPresenter class >> ruleComponentName [

	^ 'condition'
]

{ #category : #specs }
MiCBConditionBuilderPresenter class >> title [

	^ 'Rules builder'
]

{ #category : #action }
MiCBConditionBuilderPresenter >> buildComponent: aCondition [

	super buildComponent: aCondition.

	aCondition query: (usePharoCode
			 ifTrue: [ FamixCBScriptQueryHandler on: codeInputField text ]
			 ifFalse: [ FamixCBQueryHandler on: queryDroplist selectedItem ]).

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
				add: codeInputField ]
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

{ #category : #initialization }
MiCBConditionBuilderPresenter >> fillWithRuleComponent: aCondition [

	super fillWithRuleComponent: aCondition.

	aCondition severity ifNotNil: [
		severityDroplist selectItem: aCondition severity ]
]

{ #category : #initialization }
MiCBConditionBuilderPresenter >> initialize [

	super initialize.

	usePharoCode := true.

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
MiCBConditionBuilderPresenter >> initializePresenters [

	super initializePresenters.
	self initializeChoiceButtons.

	severityDroplist := self newDropList
		                    items: FamixCBAbstractSeverity allSubclasses;
		                    display: [ :item | item droplistDisplayString ];
		                    displayIcon: [ :item |
			                    self iconNamed: item iconName ];
		                    sortingBlock:
			                    [ :item | item model level ] ascending.

	queryDroplist := self newDropList
		                 startWithoutSelection;
		                 items:
			                 ((self application itemsFor: FQAbstractQuery)
				                  asOrderedCollection select: [ :each |
					                  each isValid ]);
		                 centered;
		                 yourself
]

{ #category : #initialization }
MiCBConditionBuilderPresenter >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.

	aWindowPresenter whenClosedDo: [
		self application unregisterConsumer: self ]
]

{ #category : #'instance creation' }
MiCBConditionBuilderPresenter >> newComponent [

	^ FamixCBCondition new
]

{ #category : #layout }
MiCBConditionBuilderPresenter >> titleAndSeverityLayout [

	^ self newGridLayout
		  beColumnNotHomogeneous;
		  column: 2 expand: true;
		  build: [ :builder |
			  builder
				  add: 'Condition name:';
				  add: titleField;
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
