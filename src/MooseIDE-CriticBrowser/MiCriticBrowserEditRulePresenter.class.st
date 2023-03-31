"
Dialog window called to edit a rule, uses the RulesMakerPresenter.
"
Class {
	#name : #MiCriticBrowserEditRulePresenter,
	#superclass : #MiPresenter,
	#instVars : [
		'editButton',
		'cancelButton',
		'mainWindow',
		'queryPresenter',
		'ruleToEdit'
	],
	#category : #'MooseIDE-CriticBrowser-Presenters'
}

{ #category : #'instance creation' }
MiCriticBrowserEditRulePresenter class >> on: aWindowPresenter [
	^ self new
		setMainWindow: aWindowPresenter;
		yourself.
]

{ #category : #brokerage }
MiCriticBrowserEditRulePresenter >> consume: aQuery [
	queryPresenter queryDroplist items: self fetchQueries 
]

{ #category : #layout }
MiCriticBrowserEditRulePresenter >> defaultLayout [
	^ SpBoxLayout newTopToBottom
		add: queryPresenter;
		yourself
]

{ #category : #accessing }
MiCriticBrowserEditRulePresenter >> defaultTitle [
	^ 'Rule Editor'
]

{ #category : #settings }
MiCriticBrowserEditRulePresenter >> editButtonAction [
	queryPresenter editRule: ruleToEdit.
	self window close
]

{ #category : #initialization }
MiCriticBrowserEditRulePresenter >> fetchQueries [
	^ ((self application itemsFor: FQAbstractQuery)
		asOrderedCollection) select: [ :each | each isValid ] 
]

{ #category : #testing }
MiCriticBrowserEditRulePresenter >> hasBeenEdited: aRuleComponent [
	mainWindow model hasBeenEdited: aRuleComponent.
	
]

{ #category : #initialization }
MiCriticBrowserEditRulePresenter >> initializeDialogWindow: aDialogWindowPresenter [
	aDialogWindowPresenter 
		addButton: editButton;
		addButton: cancelButton
]

{ #category : #initialization }
MiCriticBrowserEditRulePresenter >> initializeMainPresenter [
"must be called after mainWindow has been set, not before"
	queryPresenter := self instantiate: MiCriticBrowserRulesMakerPresenter on: mainWindow model
]

{ #category : #initialization }
MiCriticBrowserEditRulePresenter >> initializePresenters [ 
	editButton := self newButton.
	cancelButton := self newButton.
	
	editButton label: 'Edit rule';
		icon: (self iconNamed: #glamorousEdit);
		action: [ self editButtonAction ].
		
	cancelButton label: 'Cancel edit';
		icon: (self iconNamed: #glamorousClose);
		action: [ self window close ]
]

{ #category : #initialization }
MiCriticBrowserEditRulePresenter >> initializeWindow: aWindowPresenter [	
	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		title: self defaultTitle;
		initialExtent: 1280 @ 720
]

{ #category : #accessing }
MiCriticBrowserEditRulePresenter >> queryPresenter [
"used for test purposes, do not access outside of tests"
	^ queryPresenter
]

{ #category : #removing }
MiCriticBrowserEditRulePresenter >> remove: aQuery [
	queryPresenter queryDroplist items: self fetchQueries 
]

{ #category : #initialization }
MiCriticBrowserEditRulePresenter >> setMainWindow: aWindowPresenter [
	mainWindow := aWindowPresenter.
	self initializeMainPresenter
]

{ #category : #accessing }
MiCriticBrowserEditRulePresenter >> setRuleToEdit: aRule [
	ruleToEdit := aRule.
	queryPresenter fillRuleToEdit: ruleToEdit
]

{ #category : #updating }
MiCriticBrowserEditRulePresenter >> update: aQuery [
	queryPresenter queryDroplist items: self fetchQueries
]
