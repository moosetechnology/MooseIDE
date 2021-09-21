Class {
	#name : #MiRemoveTagCategoryCommand,
	#superclass : #MiTagCommands,
	#category : #'MooseIDE-Tagging-Manager'
}

{ #category : #'accessing - defaults' }
MiRemoveTagCategoryCommand class >> defaultName [
	^ 'Remove category'
]

{ #category : #testing }
MiRemoveTagCategoryCommand >> canBeExecuted [

	^ self context miSelectedItem isKindOf: FamixTagCategory
]

{ #category : #testing }
MiRemoveTagCategoryCommand >> execute [

	| markd item |
	item := self context miSelectedItem.
	markd := item markedTags asOrderedCollection.
	markd do: [ :t | 
		self removeTag: t.
		item markedTags remove: t ].

	self mooseModel remove: self context miSelectedItem ifAbsent: [  ]
]
