Class {
	#name : #MiRemoveTagCommand,
	#superclass : #MiTagCommands,
	#category : #'MooseIDE-Tagging-Manager'
}

{ #category : #'accessing - defaults' }
MiRemoveTagCommand class >> defaultName [
	^ 'Remove tag'
]

{ #category : #testing }
MiRemoveTagCommand >> canBeExecuted [

	^ self context miSelectedItem isKindOf: FamixTag
]

{ #category : #executing }
MiRemoveTagCommand >> execute [

	self removeTag: self context miSelectedItem
]
