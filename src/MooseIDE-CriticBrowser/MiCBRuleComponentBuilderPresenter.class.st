Class {
	#name : 'MiCBRuleComponentBuilderPresenter',
	#superclass : 'MiPresenter',
	#instVars : [
		'isForEdition',
		'browserModel',
		'summaryField',
		'selectedRuleComponent',
		'titleField',
		'codeInputField'
	],
	#category : 'MooseIDE-CriticBrowser-Presenters',
	#package : 'MooseIDE-CriticBrowser',
	#tag : 'Presenters'
}

{ #category : 'labels' }
MiCBRuleComponentBuilderPresenter class >> addButtonLabel [

	^ 'Add'
]

{ #category : 'labels' }
MiCBRuleComponentBuilderPresenter class >> alertLabel [

	^ 'Please give your {1} a code to execute.' format:
		  { self ruleComponentName capitalized }
]

{ #category : 'labels' }
MiCBRuleComponentBuilderPresenter class >> defaultCodeInput [

	self subclassResponsibility
]

{ #category : 'api' }
MiCBRuleComponentBuilderPresenter class >> initialExtent [

	^ 600 @ 400
]

{ #category : 'labels' }
MiCBRuleComponentBuilderPresenter class >> ruleComponentName [

	self subclassResponsibility
]

{ #category : 'labels' }
MiCBRuleComponentBuilderPresenter class >> summaryLabel [

	^ '{1} summary:' format: { self ruleComponentName capitalized }
]

{ #category : 'initialization' }
MiCBRuleComponentBuilderPresenter >> actionButton [

	^ isForEdition
		  ifFalse: [
			  self newButton
				  label: self class addButtonLabel;
				  iconName: #smallAdd;
				  action: [
					  self addNewComponent.
					  self withWindowDo: #close ];
				  yourself ]
		  ifTrue: [
			  self newButton
				  label: 'Confirm';
				  iconName: #glamorousEdit;
				  action: [
					  self editComponent.
					  self withWindowDo: #close ];
				  yourself ]
]

{ #category : 'action' }
MiCBRuleComponentBuilderPresenter >> addNewComponent [

	codeInputField text
		ifNil: [ self alert: self class alertLabel ]
		ifNotNil: [
			browserModel
				addChild: (self buildComponent: self newComponent)
				toContext: selectedRuleComponent ]
]

{ #category : 'initialization' }
MiCBRuleComponentBuilderPresenter >> beForEdition [

	self fillWithRuleComponent: selectedRuleComponent.
	isForEdition := true
]

{ #category : 'action' }
MiCBRuleComponentBuilderPresenter >> buildComponent: aComponent [

	aComponent name: titleField text.
	aComponent summary: summaryField text.

	^ aComponent
]

{ #category : 'action' }
MiCBRuleComponentBuilderPresenter >> editComponent [

	self buildComponent: selectedRuleComponent.

	browserModel hasBeenEdited: selectedRuleComponent
]

{ #category : 'initialization' }
MiCBRuleComponentBuilderPresenter >> fillWithRuleComponent: aRuleComponent [

	titleField text: (aRuleComponent name ifNil: [ '' ]).

	codeInputField text: aRuleComponent printAsBlock.

	summaryField text: (aRuleComponent summary ifNil: [ '' ])
]

{ #category : 'initialization' }
MiCBRuleComponentBuilderPresenter >> initialize [

	super initialize.
	isForEdition := false
]

{ #category : 'initialization' }
MiCBRuleComponentBuilderPresenter >> initializeDialogWindow: aDialogWindowPresenter [

	aDialogWindowPresenter
		addButton: self actionButton;
		addButton: (self newButton
				 label: 'Close';
				 iconName: #glamorousClose;
				 action: [ self withWindowDo: #close ];
				 yourself)
]

{ #category : 'initialization' }
MiCBRuleComponentBuilderPresenter >> initializePresenters [

	titleField := self newTextInput.
	summaryField := self newText.

	codeInputField := self newCode
		                  text: self class defaultCodeInput;
		                  yourself.
	codeInputField eventHandler whenFocusReceivedDo: [ "Set cursor to the position where some code should be added or modified"
		| pipePosition |
		pipePosition := codeInputField text findString: ']'.
		codeInputField selectionInterval:
			(pipePosition - 1 to: pipePosition - 2) ]
]

{ #category : 'initialization' }
MiCBRuleComponentBuilderPresenter >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter title:
		self class ruleComponentName capitalized , (isForEdition
			 ifTrue: [ ' editor' ]
			 ifFalse: [ ' builder' ]).
	aWindowPresenter initialExtent: self class initialExtent
]

{ #category : 'instance creation' }
MiCBRuleComponentBuilderPresenter >> newComponent [

	self subclassResponsibility
]

{ #category : 'accessing - model' }
MiCBRuleComponentBuilderPresenter >> setModelBeforeInitialization: aBrowserModel [

	browserModel := aBrowserModel.
	selectedRuleComponent := browserModel selectedRule
]

{ #category : 'layout' }
MiCBRuleComponentBuilderPresenter >> summaryLayout [

	^ self newBoxLayoutTopToBottom
		  spacing: 5;
		  add: self class summaryLabel expand: false;
		  add: summaryField;
		  yourself
]
