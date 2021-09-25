Class {
	#name : #MiCommand,
	#superclass : #CmCommand,
	#category : #'MooseIDE-Core-Command'
}

{ #category : #initialization }
MiCommand class >> defaultIconName [

	^ ''
]

{ #category : #initialization }
MiCommand class >> defaultShortcut [

	^ nil
]

{ #category : #testing }
MiCommand class >> isAbstract [

	^ self = MiCommand
]

{ #category : #converting }
MiCommand >> asSpecCommand [

	| command |
	command := super asSpecCommand
		           iconProvider: self iconProvider;
		           iconName: self class defaultIconName;
		           name: self class defaultName;
		           yourself.

	self class defaultShortcut ifNotNil: [ :keyCombination | 
		command shortcutKey: keyCombination ].

	^ command
]

{ #category : #converting }
MiCommand >> iconProvider [

	^ context application iconProvider
]
