"
Class implementing the presenter used to input contexts, using Pharo code blocks.
"
Class {
	#name : #MiCriticBrowserContextMakerPresenter,
	#superclass : #MiPresenter,
	#instVars : [
		'addButton',
		'closeButton',
		'contextTitle',
		'contextSummary',
		'codeInput',
		'mainWindow',
		'parentContext'
	],
	#category : #'MooseIDE-CriticBrowser-Presenters'
}

{ #category : #adding }
MiCriticBrowserContextMakerPresenter >> addButtonAction [

	codeInput text ifNotNil: [ 
		owner addContext: (FamixCBContext
				 							named: contextTitle text
				 							on: codeInput text
				 							summary: contextSummary text) ].
	contextTitle text: ''.
	codeInput text: '[ :collection | collection ]'.
	contextSummary text: ''
]

{ #category : #accessing }
MiCriticBrowserContextMakerPresenter >> codeInput [ 
"used for testing purposes, do not access outside of tests"
	^ codeInput
]

{ #category : #accessing }
MiCriticBrowserContextMakerPresenter >> contextSummary [
"used for testing purposes, do not access outside of tests"
	^ contextSummary
]

{ #category : #accessing }
MiCriticBrowserContextMakerPresenter >> contextTitle [
"used for testing purposes, do not access outside of tests"
	^ contextTitle
]

{ #category : #layout }
MiCriticBrowserContextMakerPresenter >> defaultLayout [
	
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
MiCriticBrowserContextMakerPresenter >> defaultTitle [
	^ 'Context builder'
]

{ #category : #'as yet unclassified' }
MiCriticBrowserContextMakerPresenter >> editContext: aContext [
	aContext name: contextTitle text.
	aContext contextBlock: codeInput text.
	aContext summary: contextSummary text.
	owner hasBeenEdited: aContext
]

{ #category : #'as yet unclassified' }
MiCriticBrowserContextMakerPresenter >> fillContextToEdit: aContext [
	contextTitle text: aContext name.
	contextSummary text: aContext summary.
	codeInput text: aContext contextBlock asString
]

{ #category : #initialization }
MiCriticBrowserContextMakerPresenter >> initializeButtons [
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
MiCriticBrowserContextMakerPresenter >> initializeDialogWindow: aDialogWindowPresenter [
	aDialogWindowPresenter 
		addButton: addButton;
		addButton: closeButton
]

{ #category : #initialization }
MiCriticBrowserContextMakerPresenter >> initializePresenters [
	
	self initializeButtons.
	
	contextTitle := self newTextInput.
	contextSummary := self newText.
	codeInput := self newCode.
	
	codeInput text: '[ :collection | collection ]'.
	
]

{ #category : #initialization }
MiCriticBrowserContextMakerPresenter >> initializeWindow: aWindowPresenter [	
	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		title: self defaultTitle;
		initialExtent: 1280 @ 720
]

{ #category : #initialization }
MiCriticBrowserContextMakerPresenter >> setMainWindow: aWindowPresenter [
	mainWindow := aWindowPresenter
]

{ #category : #initialization }
MiCriticBrowserContextMakerPresenter >> setParentContext: aContext [
	parentContext := aContext
	
]
