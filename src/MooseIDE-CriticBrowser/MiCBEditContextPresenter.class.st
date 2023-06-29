"
Dialog window called to edit a context, uses the ContextMakerPresenter.
"
Class {
	#name : #MiCBEditContextPresenter,
	#superclass : #MiPresenter,
	#instVars : [
		'addButton',
		'closeButton',
		'contextPresenter',
		'mainWindow',
		'parentContext',
		'contextToEdit',
		'editButton',
		'cancelButton'
	],
	#category : #'MooseIDE-CriticBrowser-Presenters'
}

{ #category : #'instance creation' }
MiCBEditContextPresenter class >> on: aWindowPresenter [
	^ self new
		setMainWindow: aWindowPresenter;
		yourself.
]

{ #category : #accessing }
MiCBEditContextPresenter >> contextPresenter [
"used for test purposes, do not access outside of tests"
	^ contextPresenter
]

{ #category : #layout }
MiCBEditContextPresenter >> defaultLayout [
	^ SpBoxLayout newTopToBottom
		add: contextPresenter;
		yourself
]

{ #category : #accessing }
MiCBEditContextPresenter >> defaultTitle [
	^ 'Context Editor'
]

{ #category : #settings }
MiCBEditContextPresenter >> editButtonAction [
	contextPresenter editContext: contextToEdit.
	self window close
]

{ #category : #testing }
MiCBEditContextPresenter >> hasBeenEdited: aRuleComponent [
	mainWindow model hasBeenEdited: aRuleComponent.
]

{ #category : #initialization }
MiCBEditContextPresenter >> initializeDialogWindow: aDialogWindowPresenter [
	aDialogWindowPresenter 
		addButton: editButton;
		addButton: cancelButton
]

{ #category : #initialization }
MiCBEditContextPresenter >> initializeMainPresenter [
"must be called after mainWindow has been set, not before"
	contextPresenter := self instantiate: MiCBContextMakerPresenter on: mainWindow model
]

{ #category : #initialization }
MiCBEditContextPresenter >> initializePresenters [ 
	editButton := self newButton.
	cancelButton := self newButton.
	
	editButton label: 'Edit context';
		icon: (self iconNamed: #glamorousEdit);
		action: [ self editButtonAction ].
		
	cancelButton label: 'Cancel edit';
		icon: (self iconNamed: #glamorousClose);
		action: [ self window close ]
]

{ #category : #initialization }
MiCBEditContextPresenter >> initializeWindow: aWindowPresenter [	
	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		title: self defaultTitle;
		initialExtent: 1280 @ 720
]

{ #category : #initialization }
MiCBEditContextPresenter >> setContextToEdit: aContext [
	contextToEdit := aContext.
	contextPresenter fillContextToEdit: contextToEdit
]

{ #category : #initialization }
MiCBEditContextPresenter >> setMainWindow: aWindowPresenter [
	mainWindow := aWindowPresenter.
	self initializeMainPresenter
]
