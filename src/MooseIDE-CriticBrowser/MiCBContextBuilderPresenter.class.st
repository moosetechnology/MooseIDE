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

	^ self newBoxLayoutTopToBottom
		  spacing: 5;
		  add: 'Compute context:' expand: false;
		  add: codeInput;
		  yourself
]

{ #category : #layout }
MiCBContextBuilderPresenter >> defaultLayout [

	^ self newBoxLayoutTopToBottom
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
	codeInput text: aContext contextBlock asString.
	contextSummary text: aContext summary
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

	codeInput := self newCode
		             text: '[ :collection | collection  ]';
		             yourself.
	codeInput eventHandler whenFocusReceivedDo: [ "Set cursor to the position where some code should be added or modified"
		| pipePosition |
		pipePosition := codeInput text findString: ']'.
		codeInput selectionInterval: (pipePosition - 1 to: pipePosition - 2) ].

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

	^ self newBoxLayoutTopToBottom
		  spacing: 5;
		  add: 'Context summary:' expand: false;
		  add: contextSummary;
		  yourself
]

{ #category : #layout }
MiCBContextBuilderPresenter >> titleLayout [

	^ self newBoxLayoutLeftToRight
		  spacing: 10;
		  add: 'Context name:' expand: false;
		  add: contextTitle;
		  yourself
]
