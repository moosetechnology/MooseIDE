"
Class implementing the presenter used to input contexts, using Pharo code blocks.
"
Class {
	#name : #MiCBContextBuilderPresenter,
	#superclass : #MiPresenter,
	#instVars : [
		'contextTitle',
		'contextSummary',
		'codeInput',
		'browserModel',
		'selectedContext',
		'isForEdition'
	],
	#category : #'MooseIDE-CriticBrowser-Presenters'
}

{ #category : #api }
MiCBContextBuilderPresenter class >> initialExtent [

	^ 600 @ 400
]

{ #category : #specs }
MiCBContextBuilderPresenter class >> title [

	^ 'Context builder'
]

{ #category : #initialization }
MiCBContextBuilderPresenter >> actionButton [

	^ isForEdition
		  ifFalse: [
			  self newButton
				  label: 'Add context';
				  iconName: #smallAdd;
				  action: [
					  self addNewContext.
					  self withWindowDo: #close ];
				  yourself ]
		  ifTrue: [
			  self newButton
				  label: 'Confirm';
				  iconName: #glamorousEdit;
				  action: [
					  self editContext.
					  self withWindowDo: #close ] ]
]

{ #category : #action }
MiCBContextBuilderPresenter >> addNewContext [

	codeInput text
		ifNil: [
			self application alert:
				'Please give your context a code to execute.' ]
		ifNotNil: [
			browserModel
				addChild: (self buildContext: FamixCBContext new)
				toContext: selectedContext ]
]

{ #category : #initialization }
MiCBContextBuilderPresenter >> beForEdition [

	self fillWithContext: selectedContext.
	isForEdition := true
]

{ #category : #action }
MiCBContextBuilderPresenter >> buildContext: aContext [

	aContext name: contextTitle text.
	aContext contextBlock: codeInput text.
	aContext summary: contextSummary text.

	^ aContext
]

{ #category : #layout }
MiCBContextBuilderPresenter >> codeBlockLayout [

	^ SpBoxLayout newTopToBottom
		  spacing: 5;
		  add: 'Input for context selection :' expand: false;
		  add: codeInput;
		  yourself
]

{ #category : #layout }
MiCBContextBuilderPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  spacing: 10;
		  add: self titleLayout expand: false;
		  add: self codeBlockLayout;
		  add: self summaryLayout;
		  yourself
]

{ #category : #action }
MiCBContextBuilderPresenter >> editContext [

	self buildContext: selectedContext.

	browserModel hasBeenEdited: selectedContext
]

{ #category : #initialization }
MiCBContextBuilderPresenter >> fillWithContext: aContext [

	contextTitle text: aContext name.
	contextSummary text: aContext summary.
	codeInput text: aContext contextBlock asString
]

{ #category : #initialization }
MiCBContextBuilderPresenter >> initialize [

	super initialize.
	isForEdition := false
]

{ #category : #initialization }
MiCBContextBuilderPresenter >> initializeDialogWindow: aDialogWindowPresenter [

	aDialogWindowPresenter
		addButton: self actionButton;
		addButton: (self newButton
				 label: 'Close';
				 iconName: #glamorousClose;
				 action: [ self withWindowDo: #close ];
				 yourself)
]

{ #category : #initialization }
MiCBContextBuilderPresenter >> initializePresenters [

	contextTitle := self newTextInput.

	codeInput := self newCode.
	codeInput text: '[ :collection | collection  ]'.
	codeInput eventHandler whenFocusReceivedDo: [ "Set cursor to the position where some code should be added"
		codeInput selectionInterval:
			(codeInput text size - 1 to: codeInput text size - 2) ].

	contextSummary := self newText
]

{ #category : #initialization }
MiCBContextBuilderPresenter >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter initialExtent: self class initialExtent
]

{ #category : #'accessing - model' }
MiCBContextBuilderPresenter >> setModelBeforeInitialization: aBrowserModel [

	browserModel := aBrowserModel.
	selectedContext := browserModel selectedRule
]

{ #category : #layout }
MiCBContextBuilderPresenter >> summaryLayout [

	^ SpBoxLayout newTopToBottom
		  spacing: 5;
		  add: 'Summary of the context :' asPresenter expand: false;
		  add: contextSummary expand: true;
		  yourself
]

{ #category : #layout }
MiCBContextBuilderPresenter >> titleLayout [

	^ SpBoxLayout newLeftToRight
		  spacing: 10;
		  add: 'Context name : ' expand: false;
		  add: contextTitle;
		  yourself
]
