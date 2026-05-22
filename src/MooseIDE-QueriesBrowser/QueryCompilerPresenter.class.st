"
I am used in the manual query condigurator presenter. I have a code presenter in which you can enter some valid query code that I will compile an return the object
"
Class {
	#name : 'QueryCompilerPresenter',
	#superclass : 'MiPresenter',
	#instVars : [
		'submitButton',
		'codePresenter',
		'closeButton',
		'configurationPresenter'
	],
	#category : 'MooseIDE-QueriesBrowser-Widgets',
	#package : 'MooseIDE-QueriesBrowser',
	#tag : 'Widgets'
}

{ #category : 'initialization' }
QueryCompilerPresenter >> initialExtent [

	^ 350 @ 200
]

{ #category : 'initialization' }
QueryCompilerPresenter >> initializeButtons [

	submitButton := self newButton.
	submitButton
		label: 'Submit';
		icon: (self iconNamed: #smallDoIt);
		action: [ self owner dismiss ].
	closeButton := self newButton.
	closeButton
		label: 'Close';
		action: [ self owner dismiss ]
]

{ #category : 'initialization' }
QueryCompilerPresenter >> initializeCoder [

	codePresenter := self newCode.
	codePresenter
		withoutLineNumbers;
		beForScripting;
		text: '[ :mooseEntity | "Your code here" ]'
]

{ #category : 'initialization' }
QueryCompilerPresenter >> initializeLayout [

	| tempLayout |
	tempLayout := SpBoxLayout newTopToBottom
		add: (SpBoxLayout newLeftToRight
			add: closeButton expand: false;
			addLast: submitButton expand: false;
			yourself)
		expand: false;
		add: codePresenter;
		yourself.

	self layout: (SpBoxLayout newTopToBottom
		add: tempLayout
		withConstraints: [ :constraints | 
			constraints
				height: self initialExtent y;
				width: self initialExtent x ];
		yourself)
]

{ #category : 'initialization' }
QueryCompilerPresenter >> initializePresenters [

	self initializeButtons.
	self initializeCoder.
	self initializeLayout
]

{ #category : 'as yet unclassified' }
QueryCompilerPresenter >> selectBlockBehavior [
	"Select the comment so we can start coding immediately by replacing it with the expected behavior."

	codePresenter
		selectionInterval: (18 to: codePresenter text size - 2);
		takeKeyboardFocus
]

{ #category : 'accessing - model' }
QueryCompilerPresenter >> setModelBeforeInitialization: aModel [

	configurationPresenter := aModel
]

{ #category : 'compiling' }
QueryCompilerPresenter >> updateConfigurationPresenter: aConfigurationPresenter [

	| compiledBlock currentScript |
	currentScript := configurationPresenter query script.
	(currentScript isNotNil and: [
			 codePresenter text
			 = configurationPresenter query script sourceNode sourceCode ])
		ifTrue: [ ^ self ].

	compiledBlock := codePresenter
		                 evaluate: codePresenter text
		                 onCompileError: [ :e | ^ self ]
		                 onError: [ :e | ^ self ].
	configurationPresenter computeQueryAction: compiledBlock
]
