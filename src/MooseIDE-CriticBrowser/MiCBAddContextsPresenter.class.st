"
Dialog window used to add new contexts, uses the ContextMakerPresenter.
"
Class {
	#name : #MiCBAddContextsPresenter,
	#superclass : #MiPresenter,
	#instVars : [
		'addButton',
		'closeButton',
		'contextPresenter',
		'mainWindow',
		'parentContext'
	],
	#category : #'MooseIDE-CriticBrowser-Presenters'
}

{ #category : #'instance creation' }
MiCBAddContextsPresenter class >> on: aWindowPresenter [
	^ self new
		setMainWindow: aWindowPresenter;
		yourself.
]

{ #category : #adding }
MiCBAddContextsPresenter >> addButtonAction [
	contextPresenter addButtonAction.
	self window close
]

{ #category : #adding }
MiCBAddContextsPresenter >> addContext: aContext [
	mainWindow model addChild: aContext toContext: parentContext 
]

{ #category : #accessing }
MiCBAddContextsPresenter >> contextPresenter [
"used for test purposes, do not access outside of tests"
	^ contextPresenter
]

{ #category : #layout }
MiCBAddContextsPresenter >> defaultLayout [
	^ SpBoxLayout newTopToBottom
		add: contextPresenter;
		yourself
]

{ #category : #accessing }
MiCBAddContextsPresenter >> defaultTitle [
	^ 'Context maker'
]

{ #category : #initialization }
MiCBAddContextsPresenter >> initializeDialogWindow: aDialogWindowPresenter [
	aDialogWindowPresenter 
		addButton: addButton;
		addButton: closeButton
]

{ #category : #initialization }
MiCBAddContextsPresenter >> initializeMainPresenter [
"must be called after mainWindow has been set, not before"
	contextPresenter := self instantiate: MiCBContextMakerPresenter on: mainWindow model
]

{ #category : #initialization }
MiCBAddContextsPresenter >> initializePresenters [
	addButton := self newButton.
	closeButton := self newButton.
	
	addButton label: 'Add context';
		icon: (self iconNamed: #smallAdd);
		action: [ self addButtonAction ].
		
	closeButton label: 'Close';
		icon: (self iconNamed: #glamorousClose);
		action: [ self window close ]
]

{ #category : #initialization }
MiCBAddContextsPresenter >> initializeWindow: aWindowPresenter [	
	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		title: self defaultTitle;
		initialExtent: 1280 @ 720
]

{ #category : #initialization }
MiCBAddContextsPresenter >> setMainWindow: aWindowPresenter [
	mainWindow := aWindowPresenter.
	self initializeMainPresenter
]

{ #category : #initialization }
MiCBAddContextsPresenter >> setParentContext: aContext [
	parentContext := aContext
]
