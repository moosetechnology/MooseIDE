Class {
	#name : #MiCriticBrowserAddContextPresenter,
	#superclass : #MiPresenter,
	#instVars : [
		'addButton',
		'closeButton',
		'contextTitle',
		'contextSummary',
		'codeInput',
		'mainWindow'
	],
	#category : #'MooseIDE-CriticBrowser'
}

{ #category : #'instance creation' }
MiCriticBrowserAddContextPresenter class >> on: aWindowPresenter [
	^ self new
		setMainWindow: aWindowPresenter;
		yourself.
]

{ #category : #adding }
MiCriticBrowserAddContextPresenter >> addButtonAction [

	codeInput text ifNotNil: [ 
		"owner addRule: (FamixCBContext
				 named: contextTitle text
				 on: codeInput text
				 summary: contextSummary text)" ].
	contextTitle text: ''.
	codeInput text: '[ :collection | ]'.
	contextSummary text: ''.
]

{ #category : #layout }
MiCriticBrowserAddContextPresenter >> defaultLayout [
	
	| titlePane codeBlock summaryPane |
	
	titlePane := SpBoxLayout newTopToBottom
		add: ('Rule name : ' asPresenter) expand: false;
		add: contextTitle expand: false;
		yourself.
	
	codeBlock := SpBoxLayout newTopToBottom 
		add: ('Input for context selection :' asPresenter) expand: false; 
		add: codeInput;
		yourself.
		
	summaryPane := SpBoxLayout newTopToBottom
		add: ('Summary of the context :' asPresenter) expand: false;
		add: contextSummary expand: true;
		yourself.
	
	^ SpBoxLayout newTopToBottom
		add: titlePane expand: false;
		add: codeBlock;
		add: summaryPane;
		yourself
]

{ #category : #accessing }
MiCriticBrowserAddContextPresenter >> defaultTitle [
	^ 'Context builder'
]

{ #category : #initialization }
MiCriticBrowserAddContextPresenter >> initializeButtons [
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
MiCriticBrowserAddContextPresenter >> initializeDialogWindow: aDialogWindowPresenter [
	aDialogWindowPresenter 
		addButton: addButton;
		addButton: closeButton
]

{ #category : #initialization }
MiCriticBrowserAddContextPresenter >> initializePresenters [
	
	self initializeButtons.
	
	contextTitle := self newTextInput.
	contextSummary := self newText.
	codeInput := self newCode.
	
	codeInput text: '[ :collection | ]'.
	
]

{ #category : #initialization }
MiCriticBrowserAddContextPresenter >> initializeWindow: aWindowPresenter [	
	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		title: self defaultTitle;
		initialExtent: 1280 @ 720
]

{ #category : #initialization }
MiCriticBrowserAddContextPresenter >> setMainWindow: aWindowPresenter [
	mainWindow := aWindowPresenter
]
