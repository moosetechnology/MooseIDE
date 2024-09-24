Class {
	#name : #MiHelpCommand,
	#superclass : #MiCommand,
	#instVars : [
		'helpIsOpen',
		'currentHelp'
	],
	#category : #'MooseIDE-Core-Command'
}

{ #category : #default }
MiHelpCommand class >> defaultDescription [

	^ 'What does this browser do?'
]

{ #category : #default }
MiHelpCommand class >> defaultIconName [

	^ #help
]

{ #category : #default }
MiHelpCommand class >> defaultName [

	^ 'Help'
]

{ #category : #executing }
MiHelpCommand >> execute [

	helpIsOpen
		ifFalse: [ currentHelp := self context showHelp ]
		ifTrue: [
			currentHelp dismiss.
			currentHelp := nil ].
	helpIsOpen := helpIsOpen not
]

{ #category : #initialization }
MiHelpCommand >> initialize [

	super initialize.
	helpIsOpen := false
]
