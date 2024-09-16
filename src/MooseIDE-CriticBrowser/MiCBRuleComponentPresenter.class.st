Class {
	#name : #MiCBRuleComponentPresenter,
	#superclass : #MiPresenter,
	#instVars : [
		'isForEdition',
		'browserModel',
		'summaryField',
		'selectedRuleComponent',
		'titleField',
		'codeInputField'
	],
	#category : #'MooseIDE-CriticBrowser-Presenters'
}

{ #category : #labels }
MiCBRuleComponentPresenter class >> addButtonLabel [

	^ 'Add {1}' format: { self ruleComponentName capitalized }
]

{ #category : #labels }
MiCBRuleComponentPresenter class >> alertLabel [

	^ 'Please give your {1} a code to execute.' format:
		  { self ruleComponentName capitalized }
]

{ #category : #labels }
MiCBRuleComponentPresenter class >> defaultCodeInput [

	self subclassResponsibility
]

{ #category : #labels }
MiCBRuleComponentPresenter class >> ruleComponentName [

	self subclassResponsibility
]

{ #category : #labels }
MiCBRuleComponentPresenter class >> summaryLabel [

	^ '{1} summary:' format: { self ruleComponentName capitalized }
]

{ #category : #initialization }
MiCBRuleComponentPresenter >> actionButton [

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
					  self withWindowDo: #close ] ]
]

{ #category : #action }
MiCBRuleComponentPresenter >> addNewComponent [

	codeInputField text
		ifNil: [ self alert: self class alertLabel ]
		ifNotNil: [
			browserModel
				addChild: (self buildComponent: self newComponent)
				toContext: selectedRuleComponent ]
]

{ #category : #initialization }
MiCBRuleComponentPresenter >> beForEdition [

	self fillWithRuleComponent: selectedRuleComponent.
	isForEdition := true
]

{ #category : #action }
MiCBRuleComponentPresenter >> buildComponent: aComponent [

	aComponent name: titleField text.
	aComponent summary: summaryField text.

	^ aComponent
]

{ #category : #action }
MiCBRuleComponentPresenter >> editComponent [

	self buildComponent: selectedRuleComponent.

	browserModel hasBeenEdited: selectedRuleComponent
]

{ #category : #initialization }
MiCBRuleComponentPresenter >> fillWithRuleComponent: aRuleComponent [

	titleField text: (aRuleComponent name ifNil: [ '' ]).

	codeInputField text: aRuleComponent printAsBlock.

	summaryField text: (aRuleComponent summary ifNil: [ '' ])
]

{ #category : #initialization }
MiCBRuleComponentPresenter >> initialize [

	super initialize.
	isForEdition := false
]

{ #category : #initialization }
MiCBRuleComponentPresenter >> initializeDialogWindow: aDialogWindowPresenter [

	aDialogWindowPresenter
		addButton: self actionButton;
		addButton: (self newButton
				 label: 'Close';
				 iconName: #glamorousClose;
				 action: [ self withWindowDo: #close ];
				 yourself)
]

{ #category : #initialization }
MiCBRuleComponentPresenter >> initializePresenters [

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

{ #category : #initialization }
MiCBRuleComponentPresenter >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter initialExtent: self class initialExtent
]

{ #category : #'instance creation' }
MiCBRuleComponentPresenter >> newComponent [

	self subclassResponsibility
]

{ #category : #'accessing - model' }
MiCBRuleComponentPresenter >> setModelBeforeInitialization: aBrowserModel [

	browserModel := aBrowserModel.
	selectedRuleComponent := browserModel selectedRule
]

{ #category : #layout }
MiCBRuleComponentPresenter >> summaryLayout [

	^ self newBoxLayoutTopToBottom
		  spacing: 5;
		  add: self class summaryLabel expand: false;
		  add: summaryField;
		  yourself
]
