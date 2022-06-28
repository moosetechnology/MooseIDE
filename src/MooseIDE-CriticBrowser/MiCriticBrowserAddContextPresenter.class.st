Class {
	#name : #MiCriticBrowserAddContextPresenter,
	#superclass : #MiPresenter,
	#instVars : [
		'addButton',
		'closeButton',
		'mainWindow',
		'ruleTitle',
		'codePresenter',
		'ruleSummary'
	],
	#category : #'MooseIDE-CriticBrowser'
}

{ #category : #layout }
MiCriticBrowserAddContextPresenter >> defaultLayout [
	
	| titlePane codeBlock summaryPane |
	
	titlePane := SpBoxLayout newTopToBottom
		add: ('Rule name : ' asPresenter) expand: false;
		add: ruleTitle expand: false;
		yourself.
	
	codeBlock := SpBoxLayout newTopToBottom 
		add: ('Input for context selection :' asPresenter) expand: false; 
		add: codePresenter;
		yourself.
		
	summaryPane := SpBoxLayout newTopToBottom
		add: ('Summary of the context :' asPresenter) expand: false;
		add: ruleSummary expand: true;
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
	
	addButton label: 'Add query';
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
	
	ruleTitle := self newTextInput.
	ruleSummary := self newText.
	codePresenter := self newCode.
	
	codePresenter text: '[ :collection | ]'.
	
]

{ #category : #initialization }
MiCriticBrowserAddContextPresenter >> initializeWindow: aWindowPresenter [	
	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		title: self defaultTitle;
		initialExtent: 1280 @ 720
]
