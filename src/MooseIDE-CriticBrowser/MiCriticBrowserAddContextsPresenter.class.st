"
Dialog window used to add new contexts, uses the ContextMakerPresenter.
"
Class {
	#name : #MiCriticBrowserAddContextsPresenter,
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
MiCriticBrowserAddContextsPresenter class >> on: aWindowPresenter [
	^ self new
		setMainWindow: aWindowPresenter;
		yourself.
]

{ #category : #adding }
MiCriticBrowserAddContextsPresenter >> addButtonAction [
	contextPresenter addButtonAction.
	self window close
]

{ #category : #adding }
MiCriticBrowserAddContextsPresenter >> addContext: aContext [
	mainWindow model addChild: aContext toContext: parentContext 
]

{ #category : #accessing }
MiCriticBrowserAddContextsPresenter >> contextPresenter [
"used for test purposes, do not access outside of tests"
	^ contextPresenter
]

{ #category : #layout }
MiCriticBrowserAddContextsPresenter >> defaultLayout [
	^ SpBoxLayout newTopToBottom
		add: contextPresenter;
		yourself
]

{ #category : #accessing }
MiCriticBrowserAddContextsPresenter >> defaultTitle [
	^ 'Context maker'
]

{ #category : #initialization }
MiCriticBrowserAddContextsPresenter >> initializeDialogWindow: aDialogWindowPresenter [
	aDialogWindowPresenter 
		addButton: addButton;
		addButton: closeButton
]

{ #category : #initialization }
MiCriticBrowserAddContextsPresenter >> initializeMainPresenter [
"must be called after mainWindow has been set, not before"
	contextPresenter := self instantiate: MiCriticBrowserContextMakerPresenter on: mainWindow model
]

{ #category : #initialization }
MiCriticBrowserAddContextsPresenter >> initializePresenters [
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
MiCriticBrowserAddContextsPresenter >> initializeWindow: aWindowPresenter [	
	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		title: self defaultTitle;
		initialExtent: 1280 @ 720
]

{ #category : #initialization }
MiCriticBrowserAddContextsPresenter >> setMainWindow: aWindowPresenter [
	mainWindow := aWindowPresenter.
	self initializeMainPresenter
]

{ #category : #initialization }
MiCriticBrowserAddContextsPresenter >> setParentContext: aContext [
	parentContext := aContext
]
