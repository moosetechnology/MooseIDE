"
Class implementing the presenter used to input queries, can use Pharo code or queries produced by the Queries Browser.
"
Class {
	#name : #MiCBRulesMakerPresenter,
	#superclass : #MiPresenter,
	#instVars : [
		'codeButton',
		'queriesBrowserButton',
		'codePresenter',
		'codeInput',
		'queriesBrowserPresenter',
		'queryDroplist',
		'changeableBlock',
		'ruleTitle',
		'ruleSummary',
		'severityDroplist'
	],
	#category : #'MooseIDE-CriticBrowser-Presenters'
}

{ #category : #adding }
MiCBRulesMakerPresenter >> addButtonAction [
	codeButton state 
		ifTrue: [ self addInputtedCodeRule ] 
		ifFalse: [ self addInputtedFQRule ].
	ruleTitle text: ''.
	ruleSummary text: ''
]

{ #category : #adding }
MiCBRulesMakerPresenter >> addInputtedCodeRule [

	codeInput text ifNotNil: [ 
		owner addCondition: (FamixCBCondition
				 named: ruleTitle text
				 on: (MiCBScriptQueryHandler on: codeInput text)
				 summary: ruleSummary text
				 severity: severityDroplist selectedItem) ].
	codeInput text: '[ :entity | entity ]'
]

{ #category : #adding }
MiCBRulesMakerPresenter >> addInputtedFQRule [

	queryDroplist selectedItem ifNotNil: [
		owner addCondition: (FamixCBCondition
				 named: ruleTitle text
				 on: (MiCBQueryHandler on: queryDroplist selectedItem)
				 summary: ruleSummary text
				 severity: severityDroplist selectedItem) ]
]

{ #category : #'buttons actions' }
MiCBRulesMakerPresenter >> codeButtonAction [
	changeableBlock 
		removeAll;
		add: ('Input for code query :' asPresenter) expand: false;
		add: codePresenter.
	codeInput show. queryDroplist hide
]

{ #category : #'accessing - tests' }
MiCBRulesMakerPresenter >> codeInput [
"used for testing purposes, do not access outside of tests"
	^ codeInput
]

{ #category : #layout }
MiCBRulesMakerPresenter >> defaultLayout [
	
	| choiceBar titlePane summaryPane severityPane |
	
	choiceBar := SpBoxLayout newLeftToRight 
		add: codeButton;
		add: queriesBrowserButton;
		beHomogeneous;
		yourself.
	
	titlePane := SpBoxLayout newTopToBottom
		add: ('Rule name : ' asPresenter) expand: false;
		add: ruleTitle expand: false;
		yourself.
		
	severityPane := SpBoxLayout newTopToBottom
		add: ('Severity : ' asPresenter) expand: false;
		add: severityDroplist expand: false;
		yourself.
	
	changeableBlock := SpBoxLayout newTopToBottom 
		add: ('Input for code query :' asPresenter) expand: false; 
		add: codePresenter;
		yourself.
		
	summaryPane := SpBoxLayout newTopToBottom
		add: ('Summary of the rule :' asPresenter) expand: false;
		add: ruleSummary expand: true;
		yourself.
	
	^ SpBoxLayout newTopToBottom
		add: choiceBar expand: false;
		spacing: 5;
		add: titlePane expand: false;
		add: severityPane expand: false;
		add: changeableBlock;
		add: summaryPane;
		yourself
		
]

{ #category : #accessing }
MiCBRulesMakerPresenter >> defaultTitle [
	^ 'Rules maker'
]

{ #category : #editing }
MiCBRulesMakerPresenter >> editRule: aCondition [

	aCondition name: ruleTitle text.
	aCondition query: (codeButton state
			 ifTrue: [ MiCBScriptQueryHandler on: codeInput text ]
			 ifFalse: [ MiCBQueryHandler on: queryDroplist selectedItem ]).
	aCondition summary: ruleSummary text.
	aCondition severity: severityDroplist selectedItem.
	owner hasBeenEdited: aCondition
]

{ #category : #filling }
MiCBRulesMakerPresenter >> fillRuleToEdit: aRule [

	ruleTitle text: aRule name.
	ruleSummary text: aRule summary.
	aRule severity ifNotNil: [
		severityDroplist selectItem: aRule severity ].
	codeInput text: aRule query asRuleEditorString
]

{ #category : #initialization }
MiCBRulesMakerPresenter >> initializeButtons [
	codeButton := self newRadioButton.
	queriesBrowserButton := self newRadioButton.
	
	codeButton label: 'Pharo Code';
		whenActivatedDo: [ self codeButtonAction ];
		associatedRadioButtons: { queriesBrowserButton }.
	
	queriesBrowserButton label: 'Queries Browser';
		whenActivatedDo: [ self queriesBrowserButtonAction ]
]

{ #category : #initialization }
MiCBRulesMakerPresenter >> initializePresenters [

	self initializeButtons.

	ruleTitle := self newTextInput.
	ruleSummary := self newText.
	codeInput := self newCode.
	queryDroplist := self newDropList.

	codeInput text: '[ :entity | entity ]'.

	codePresenter := MiPresenter new
		                 layout: (SpBoxLayout newTopToBottom
				                  add: codeInput;
				                  yourself);
		                 yourself.

	queryDroplist
		startWithoutSelection;
		items: owner fetchQueries;
		centered.

	queriesBrowserPresenter := MiPresenter new
		                           layout: (SpBoxLayout newTopToBottom
				                            add: queryDroplist expand: false;
				                            yourself);
		                           yourself.

	severityDroplist := self newDropList
		                    items:
			                    MiCBAbstractSeverity allSubclasses;
		                    display: [ :item | 
			                    item title , ' (Level = ' , item level asString, ')' ];
		                    displayIcon: [ :item | 
			                    self iconNamed: item iconName ];
		                    sortingBlock: [ :a :b | a model level < b model level ]
]

{ #category : #initialization }
MiCBRulesMakerPresenter >> initializeWindow: aWindowPresenter [	
	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		title: self defaultTitle;
		initialExtent: 460 @ 460
]

{ #category : #accessing }
MiCBRulesMakerPresenter >> queriesBrowserButton [
	^ queriesBrowserButton
]

{ #category : #'buttons actions' }
MiCBRulesMakerPresenter >> queriesBrowserButtonAction [
	changeableBlock 
		removeAll; 
		add: ('Choose a query :' asPresenter) expand: false;
		add: queriesBrowserPresenter.
	codeInput hide. queryDroplist show.
]

{ #category : #'accessing - tests' }
MiCBRulesMakerPresenter >> queryDroplist [
	^ queryDroplist
]

{ #category : #'accessing - tests' }
MiCBRulesMakerPresenter >> ruleSummary [
"used for testing purposes, do not access outside of tests"
	^ ruleSummary
]

{ #category : #'accessing - tests' }
MiCBRulesMakerPresenter >> ruleTitle [
"used for testing purposes, do not access outside of tests"
	^ ruleTitle
]
