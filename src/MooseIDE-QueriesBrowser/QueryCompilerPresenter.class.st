"
I am used in the manual query condigurator presenter. I have a code presenter in which you can enter some valid query code that I will compile an return the object
"
Class {
	#name : #QueryCompilerPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'submitButton',
		'codePresenter'
	],
	#category : #'MooseIDE-QueriesBrowser-Widgets'
}

{ #category : #initialization }
QueryCompilerPresenter >> initializeButtons [

	submitButton := self newButton.
	submitButton
		label: 'Submit';
		icon: (self iconNamed: #smallDoIt)
]

{ #category : #initialization }
QueryCompilerPresenter >> initializeCoder [

	codePresenter := self newCode.
	codePresenter
		withoutLineNumbers;
		beForScripting
]

{ #category : #initialization }
QueryCompilerPresenter >> initializeLayout [

	self layout: (SpBoxLayout newTopToBottom
		add: (SpBoxLayout newLeftToRight
			addLast: submitButton expand: false;
			yourself)
		expand: false;
		add: codePresenter
		withConstraints: [ :c |
			c
				height: 150;
				width: 300];
		yourself)
]

{ #category : #initialization }
QueryCompilerPresenter >> initializePresenters [

	self initializeButtons.
	self initializeCoder.
	self initializeLayout
]
