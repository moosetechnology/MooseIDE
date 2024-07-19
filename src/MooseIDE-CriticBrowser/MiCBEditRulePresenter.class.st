"
Dialog window called to edit a rule, uses the RulesMakerPresenter.
"
Class {
	#name : #MiCBEditRulePresenter,
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
MiCBEditRulePresenter class >> on: aWindowPresenter [
	^ self new
		setMainWindow: aWindowPresenter;
		yourself.
]

{ #category : #brokerage }
MiCBEditRulePresenter >> consume: aQuery [
	queryPresenter queryDroplist items: self fetchQueries 
]

{ #category : #layout }
MiCBEditRulePresenter >> defaultLayout [
	^ SpBoxLayout newTopToBottom
		add: queryPresenter;
		yourself
]

{ #category : #accessing }
MiCBEditRulePresenter >> defaultTitle [
	^ 'Rule Editor'
]

{ #category : #settings }
MiCBEditRulePresenter >> editButtonAction [
	queryPresenter editRule: ruleToEdit.
	self window close
]

{ #category : #initialization }
MiCBEditRulePresenter >> fetchQueries [
	^ ((self application itemsFor: FQAbstractQuery)
		asOrderedCollection) select: [ :each | each isValid ] 
]

{ #category : #testing }
MiCBEditRulePresenter >> hasBeenEdited: aRuleComponent [
	mainWindow model hasBeenEdited: aRuleComponent.
	
]

{ #category : #initialization }
MiCBEditRulePresenter >> initializeDialogWindow: aDialogWindowPresenter [
	aDialogWindowPresenter 
		addButton: editButton;
		addButton: cancelButton
]

{ #category : #initialization }
MiCBEditRulePresenter >> initializeMainPresenter [
"must be called after mainWindow has been set, not before"
	queryPresenter := self instantiate: MiCBRulesMakerPresenter on: mainWindow model
]

{ #category : #initialization }
MiCBEditRulePresenter >> initializePresenters [ 
	editButton := self newButton.
	cancelButton := self newButton.
	
	editButton label: 'Confirm';
		icon: (self iconNamed: #glamorousEdit);
		action: [ self editButtonAction ].
		
	cancelButton label: 'Cancel edit';
		icon: (self iconNamed: #glamorousClose);
		action: [ self window close ]
]

{ #category : #initialization }
MiCBEditRulePresenter >> initializeWindow: aWindowPresenter [	
	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		title: self defaultTitle;
		initialExtent: 1280 @ 720
]

{ #category : #accessing }
MiCBEditRulePresenter >> queryPresenter [
"used for test purposes, do not access outside of tests"
	^ queryPresenter
]

{ #category : #removing }
MiCBEditRulePresenter >> remove: aQuery [
	queryPresenter queryDroplist items: self fetchQueries 
]

{ #category : #initialization }
MiCBEditRulePresenter >> setMainWindow: aWindowPresenter [
	mainWindow := aWindowPresenter.
	self initializeMainPresenter
]

{ #category : #accessing }
MiCBEditRulePresenter >> setRuleToEdit: aRule [
	ruleToEdit := aRule.
	queryPresenter fillRuleToEdit: ruleToEdit
]

{ #category : #updating }
MiCBEditRulePresenter >> update: aQuery [
	queryPresenter queryDroplist items: self fetchQueries
]
