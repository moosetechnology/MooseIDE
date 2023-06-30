"
Dialog window used to add new rules, uses the RulesMakerPresenter.
"
Class {
	#name : #MiCBAddRulesPresenter,
	#superclass : #MiPresenter,
	#instVars : [
		'addButton',
		'closeButton',
		'mainWindow',
		'queryPresenter',
		'parentContext'
	],
	#category : #'MooseIDE-CriticBrowser-Presenters'
}

{ #category : #'instance creation' }
MiCBAddRulesPresenter class >> on: aWindowPresenter [
	^ self new
		setMainWindow: aWindowPresenter;
		yourself.
]

{ #category : #adding }
MiCBAddRulesPresenter >> addButtonAction [
	queryPresenter addButtonAction.
	self window close
]

{ #category : #adding }
MiCBAddRulesPresenter >> addCondition: aFamixCBCondition [ 
	mainWindow model addChild: aFamixCBCondition toContext: parentContext
]

{ #category : #initialization }
MiCBAddRulesPresenter >> consume: aQuery [
	queryPresenter queryDroplist items: self fetchQueries 
]

{ #category : #layout }
MiCBAddRulesPresenter >> defaultLayout [
	^ SpBoxLayout newTopToBottom
		add: queryPresenter;
		yourself
]

{ #category : #accessing }
MiCBAddRulesPresenter >> defaultTitle [
	^ 'Rules maker'
]

{ #category : #initialization }
MiCBAddRulesPresenter >> fetchQueries [
	^ ((self application itemsFor: FQAbstractQuery)
		asOrderedCollection) select: [ :each | each isValid ] 
]

{ #category : #initialization }
MiCBAddRulesPresenter >> initializeDialogWindow: aDialogWindowPresenter [
	aDialogWindowPresenter 
		addButton: addButton;
		addButton: closeButton
]

{ #category : #initialization }
MiCBAddRulesPresenter >> initializeMainPresenter [
"must be called after mainWindow has been set, not before"
	queryPresenter := self instantiate: MiCBRulesMakerPresenter on: mainWindow model
]

{ #category : #initialization }
MiCBAddRulesPresenter >> initializePresenters [
	addButton := self newButton.
	closeButton := self newButton.
	
	addButton label: 'Add condition';
		icon: (self iconNamed: #smallAdd);
		action: [ self addButtonAction ].
		
	closeButton label: 'Close';
		icon: (self iconNamed: #glamorousClose);
		action: [ self window close ]
]

{ #category : #initialization }
MiCBAddRulesPresenter >> initializeWindow: aWindowPresenter [	
	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		title: self defaultTitle;
		initialExtent: 1280 @ 720
]

{ #category : #accessing }
MiCBAddRulesPresenter >> queryPresenter [
"used for test purposes, do not access outside of tests"
	^ queryPresenter
]

{ #category : #removing }
MiCBAddRulesPresenter >> remove: aQuery [
	queryPresenter queryDroplist items: self fetchQueries 
]

{ #category : #accessing }
MiCBAddRulesPresenter >> setMainWindow: aWindowPresenter [
	mainWindow := aWindowPresenter.
	self initializeMainPresenter
]

{ #category : #initialization }
MiCBAddRulesPresenter >> setParentContext: aContext [
	parentContext := aContext
]

{ #category : #updating }
MiCBAddRulesPresenter >> update: aQuery [
	queryPresenter queryDroplist items: self fetchQueries 
]
