Class {
	#name : #MiCommand,
	#superclass : #CmCommand,
	#category : #'MooseIDE-Core-Command'
}

{ #category : #default }
MiCommand class >> defaultIconName [

	^ ''
]

{ #category : #default }
MiCommand class >> defaultShortcut [

	^ nil
]

{ #category : #testing }
MiCommand class >> isAbstract [

	^ self = MiCommand
]

{ #category : #converting }
MiCommand >> application [

	^ context application
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

	^ self application iconProvider
]
