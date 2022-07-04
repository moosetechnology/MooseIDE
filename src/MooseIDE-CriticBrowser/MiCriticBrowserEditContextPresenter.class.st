Class {
	#name : #MiCriticBrowserEditContextPresenter,
	#superclass : #MiPresenter,
	#instVars : [
		'addButton',
		'closeButton',
		'contextPresenter',
		'mainWindow',
		'parentContext',
		'contextToEdit'
	],
	#category : #'MooseIDE-CriticBrowser-Presenters'
}

{ #category : #'instance creation' }
MiCriticBrowserEditContextPresenter class >> on: aWindowPresenter [
	^ self new
		setMainWindow: aWindowPresenter;
		yourself.
]

{ #category : #accessing }
MiCriticBrowserEditContextPresenter >> contextPresenter [
"used for test purposes, do not access outside of tests"
	^ contextPresenter
]

{ #category : #layout }
MiCriticBrowserEditContextPresenter >> defaultLayout [
	^ SpBoxLayout newTopToBottom
		add: contextPresenter;
		yourself
]

{ #category : #accessing }
MiCriticBrowserEditContextPresenter >> defaultTitle [
	^ 'Context Editor'
]

{ #category : #settings }
MiCriticBrowserEditContextPresenter >> editButtonAction [
	contextPresenter editContext: contextToEdit.
	self window close
]

{ #category : #testing }
MiCriticBrowserEditContextPresenter >> hasBeenEdited: aRuleComponent [
	mainWindow model hasBeenEdited: aRuleComponent.
]

{ #category : #initialization }
MiCriticBrowserEditContextPresenter >> initializeMainPresenter [
"must be called after mainWindow has been set, not before"
	contextPresenter := self instantiate: MiCriticBrowserContextMakerPresenter on: mainWindow model
]

{ #category : #initialization }
MiCriticBrowserEditContextPresenter >> initializeWindow: aWindowPresenter [	
	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		title: self defaultTitle;
		initialExtent: 1280 @ 720
]

{ #category : #initialization }
MiCriticBrowserEditContextPresenter >> setContextToEdit: aContext [
	contextToEdit := aContext.
	contextPresenter fillRuleToEdit: contextToEdit
]

{ #category : #initialization }
MiCriticBrowserEditContextPresenter >> setMainWindow: aWindowPresenter [
	mainWindow := aWindowPresenter.
	self initializeMainPresenter
]
