"
Dialog window used to add new rules, uses the RulesMakerPresenter.
"
Class {
	#name : #MiCriticBrowserAddRulesPresenter,
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
MiCriticBrowserAddRulesPresenter class >> on: aWindowPresenter [
	^ self new
		setMainWindow: aWindowPresenter;
		yourself.
]

{ #category : #adding }
MiCriticBrowserAddRulesPresenter >> addButtonAction [
	queryPresenter addButtonAction.
	self window close
]

{ #category : #adding }
MiCriticBrowserAddRulesPresenter >> addCondition: aFamixCBCondition [ 
	mainWindow model addChild: aFamixCBCondition toContext: parentContext
]

{ #category : #initialization }
MiCriticBrowserAddRulesPresenter >> consume: aQuery [
	queryPresenter queryDroplist items: self fetchQueries 
]

{ #category : #layout }
MiCriticBrowserAddRulesPresenter >> defaultLayout [
	^ SpBoxLayout newTopToBottom
		add: queryPresenter;
		yourself
]

{ #category : #accessing }
MiCriticBrowserAddRulesPresenter >> defaultTitle [
	^ 'Rules maker'
]

{ #category : #initialization }
MiCriticBrowserAddRulesPresenter >> fetchQueries [
	^ ((self application itemsFor: FQAbstractQuery)
		asOrderedCollection) select: [ :each | each isValid ] 
]

{ #category : #initialization }
MiCriticBrowserAddRulesPresenter >> initializeDialogWindow: aDialogWindowPresenter [
	aDialogWindowPresenter 
		addButton: addButton;
		addButton: closeButton
]

{ #category : #initialization }
MiCriticBrowserAddRulesPresenter >> initializeMainPresenter [
"must be called after mainWindow has been set, not before"
	queryPresenter := self instantiate: MiCriticBrowserRulesMakerPresenter on: mainWindow model
]

{ #category : #initialization }
MiCriticBrowserAddRulesPresenter >> initializePresenters [
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
MiCriticBrowserAddRulesPresenter >> initializeWindow: aWindowPresenter [	
	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		title: self defaultTitle;
		initialExtent: 1280 @ 720
]

{ #category : #accessing }
MiCriticBrowserAddRulesPresenter >> queryPresenter [
"used for test purposes, do not access outside of tests"
	^ queryPresenter
]

{ #category : #removing }
MiCriticBrowserAddRulesPresenter >> remove: aQuery [
	queryPresenter queryDroplist items: self fetchQueries 
]

{ #category : #accessing }
MiCriticBrowserAddRulesPresenter >> setMainWindow: aWindowPresenter [
	mainWindow := aWindowPresenter.
	self initializeMainPresenter
]

{ #category : #initialization }
MiCriticBrowserAddRulesPresenter >> setParentContext: aContext [
	parentContext := aContext
]

{ #category : #updating }
MiCriticBrowserAddRulesPresenter >> update: aQuery [
	queryPresenter queryDroplist items: self fetchQueries 
]
