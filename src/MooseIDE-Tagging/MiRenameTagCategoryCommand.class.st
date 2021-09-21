Class {
	#name : #MiRenameTagCategoryCommand,
	#superclass : #MiTagCommands,
	#category : #'MooseIDE-Tagging-Manager'
}

{ #category : #'accessing - defaults' }
MiRenameTagCategoryCommand class >> defaultName [
	^ 'Rename category'
]

{ #category : #executing }
MiRenameTagCategoryCommand >> canBeExecuted [

	^ self context miSelectedItem isKindOf: FamixTagCategory
]

{ #category : #executing }
MiRenameTagCategoryCommand >> execute [

	| name |
	name := UIManager default
		        request: 'Please enter a name'
		        initialAnswer: self context miSelectedItem name.
	name ifNil: [ ^ self ].

	self context miSelectedItem name: name
]
