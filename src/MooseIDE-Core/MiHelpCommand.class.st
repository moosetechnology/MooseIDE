Class {
	#name : #MiHelpCommand,
	#superclass : #MiCommand,
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

	self context showHelp
]
