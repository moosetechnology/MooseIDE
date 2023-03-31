"
Class implementing the presenter used to input queries, can use Pharo code or queries produced by the Queries Browser.
"
Class {
	#name : #MiCriticBrowserRulesMakerPresenter,
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
MiCriticBrowserRulesMakerPresenter >> addButtonAction [
	codeButton state 
		ifTrue: [ self addInputtedCodeRule ] 
		ifFalse: [ self addInputtedFQRule ].
	ruleTitle text: ''.
	ruleSummary text: ''
]

{ #category : #adding }
MiCriticBrowserRulesMakerPresenter >> addInputtedCodeRule [

	codeInput text ifNotNil: [ 
		owner addCondition: (FamixCBCondition
				 named: ruleTitle text
				 on: (MiCriticBrowserPharoCodeQuery on: codeInput text)
				 summary: ruleSummary text
				 severity: severityDroplist selectedItem) ].
	codeInput text: '[ :entity | entity ]'
]

{ #category : #adding }
MiCriticBrowserRulesMakerPresenter >> addInputtedFQRule [

	queryDroplist selectedItem ifNotNil: [ 
		owner addCondition: (FamixCBCondition
				 named: ruleTitle text
				 on: (MiCriticBrowserFQQuery on: queryDroplist selectedItem)
				 summary: ruleSummary text
				 severity: severityDroplist selectedItem) ]
]

{ #category : #'buttons actions' }
MiCriticBrowserRulesMakerPresenter >> codeButtonAction [
	changeableBlock 
		removeAll;
		add: ('Input for code query :' asPresenter) expand: false;
		add: codePresenter.
	codeInput show. queryDroplist hide
]

{ #category : #'accessing - tests' }
MiCriticBrowserRulesMakerPresenter >> codeInput [
"used for testing purposes, do not access outside of tests"
	^ codeInput
]

{ #category : #layout }
MiCriticBrowserRulesMakerPresenter >> defaultLayout [
	
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
MiCriticBrowserRulesMakerPresenter >> defaultTitle [
	^ 'Rules maker'
]

{ #category : #editing }
MiCriticBrowserRulesMakerPresenter >> editRule: aCondition [
	aCondition name: ruleTitle text.
	aCondition query: (codeButton state 
		ifTrue: [ MiCriticBrowserPharoCodeQuery on: (codeInput text) ] 
		ifFalse: [ MiCriticBrowserFQQuery on: queryDroplist selectedItem ]).
	aCondition summary: ruleSummary text.
	aCondition severity: severityDroplist selectedItem.
	owner hasBeenEdited: aCondition
]

{ #category : #filling }
MiCriticBrowserRulesMakerPresenter >> fillRuleToEdit: aRule [

	ruleTitle text: aRule name.
	ruleSummary text: aRule summary.
	aRule severity ifNotNil: [ 
		severityDroplist selectItem: aRule severity ].
	aRule query class = MiCriticBrowserPharoCodeQuery
		ifTrue: [ codeInput text: aRule query query asString ]
		ifFalse: [ codeInput text: '[ :entity | entity ]' ]
]

{ #category : #initialization }
MiCriticBrowserRulesMakerPresenter >> initializeButtons [
	codeButton := self newRadioButton.
	queriesBrowserButton := self newRadioButton.
	
	codeButton label: 'Pharo Code';
		whenActivatedDo: [ self codeButtonAction ];
		associatedRadioButtons: { queriesBrowserButton }.
	
	queriesBrowserButton label: 'Queries Browser';
		whenActivatedDo: [ self queriesBrowserButtonAction ]
]

{ #category : #initialization }
MiCriticBrowserRulesMakerPresenter >> initializePresenters [

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
			                    AbstractSeverity allSubclasses;
		                    display: [ :item | 
			                    item title , ' (Level = ' , item level asString, ')' ];
		                    displayIcon: [ :item | 
			                    self iconNamed: item iconName ];
		                    sortingBlock: [ :a :b | a model level < b model level ]
]

{ #category : #initialization }
MiCriticBrowserRulesMakerPresenter >> initializeWindow: aWindowPresenter [	
	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		title: self defaultTitle;
		initialExtent: 460 @ 460
]

{ #category : #accessing }
MiCriticBrowserRulesMakerPresenter >> queriesBrowserButton [
	^ queriesBrowserButton
]

{ #category : #'buttons actions' }
MiCriticBrowserRulesMakerPresenter >> queriesBrowserButtonAction [
	changeableBlock 
		removeAll; 
		add: ('Choose a query :' asPresenter) expand: false;
		add: queriesBrowserPresenter.
	codeInput hide. queryDroplist show.
]

{ #category : #'accessing - tests' }
MiCriticBrowserRulesMakerPresenter >> queryDroplist [
	^ queryDroplist
]

{ #category : #'accessing - tests' }
MiCriticBrowserRulesMakerPresenter >> ruleSummary [
"used for testing purposes, do not access outside of tests"
	^ ruleSummary
]

{ #category : #'accessing - tests' }
MiCriticBrowserRulesMakerPresenter >> ruleTitle [
"used for testing purposes, do not access outside of tests"
	^ ruleTitle
]
