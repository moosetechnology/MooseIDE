Class {
	#name : #MiHelpCommand,
	#superclass : #MiCommand,
	#category : #'MooseIDE-Core-Command'
}

{ #category : #'accessing - defaults' }
MiHelpCommand class >> defaultDescription [

	^ 'What does this browser do?'
]

{ #category : #initialization }
MiHelpCommand class >> defaultIconName [

	^ #help
]

{ #category : #'accessing - defaults' }
MiHelpCommand class >> defaultName [

	^ 'Help'
]

{ #category : #execution }
MiHelpCommand >> execute [

	self context showHelp
]
