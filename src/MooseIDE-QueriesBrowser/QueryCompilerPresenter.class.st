"
I am used in the manual query condigurator presenter. I have a code presenter in which you can enter some valid query code that I will compile an return the object
"
Class {
	#name : 'QueryCompilerPresenter',
	#superclass : 'MiPresenter',
	#instVars : [
		'submitButton',
		'codePresenter',
		'configuratorPresenter',
		'closeButton'
	],
	#category : 'MooseIDE-QueriesBrowser-Widgets',
	#package : 'MooseIDE-QueriesBrowser',
	#tag : 'Widgets'
}

{ #category : 'accessing' }
QueryCompilerPresenter >> code [
	^ codePresenter text
]

{ #category : 'compiling' }
QueryCompilerPresenter >> compileQuery [

	| compiledQuery |
	compiledQuery := codePresenter
		evaluate: codePresenter text
		onCompileError: [ :e | ^ self ]
		onError: [ :e | e pass ].
	compiledQuery beChildOf: configuratorPresenter queriesBrowser rootQuery.
	^ compiledQuery
]

{ #category : 'initialization' }
QueryCompilerPresenter >> initialExtent [

	^ 350 @ 200
]

{ #category : 'initialization' }
QueryCompilerPresenter >> initialize [ 
	super initialize.
	codePresenter text: 'FQCollectScriptQuery script: [ :mooseEntity | "Your code here" ]'
]

{ #category : 'initialization' }
QueryCompilerPresenter >> initializeButtons [
	
	submitButton := self newButton.
	submitButton
		label: 'Submit';
		icon: (self iconNamed: #smallDoIt).
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
		beForScripting
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

{ #category : 'accessing - model' }
QueryCompilerPresenter >> setModelBeforeInitialization: aModel [

	configuratorPresenter := aModel
]

{ #category : 'compiling' }
QueryCompilerPresenter >> submitQueryAction: aBlock [

	submitButton action: aBlock
]
