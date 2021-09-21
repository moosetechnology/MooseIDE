Class {
	#name : #MiAddTagCommand,
	#superclass : #MiTagCommands,
	#category : #'MooseIDE-Tagging-Manager'
}

{ #category : #'accessing - defaults' }
MiAddTagCommand class >> defaultName [
	^ 'Add tag'
]

{ #category : #testing }
MiAddTagCommand >> canBeExecuted [

	^ self context miSelectedItem isKindOf: FamixTagCategory
]

{ #category : #testing }
MiAddTagCommand >> execute [

	| name tag |
	name := UIManager default request: 'Please enter a tag name'.
	name ifNil: [ ^ self ].
	tag := self context mooseModel createTagNamed: name.
	tag addCategory: self context miSelectedItem.
	self context refresh
]
