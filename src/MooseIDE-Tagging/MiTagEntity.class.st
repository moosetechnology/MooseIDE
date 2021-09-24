Class {
	#name : #MiTagEntity,
	#superclass : #MiTagCommands,
	#instVars : [
		'tag',
		'removal'
	],
	#category : #'MooseIDE-Tagging-Manager'
}

{ #category : #'accessing - defaults' }
MiTagEntity class >> buildCommandsGroupWith: aPresenter forRoot: rootCommandGroup [

	| group tags groupCat categories model element |
	(self canBeExecutedOn: aPresenter miSelectedItem) ifFalse: [ ^ self ].
	model := aPresenter miSelectedItem mooseModel.
	element := aPresenter miSelectedItem.


	group := CmCommandGroup new.
	group name: 'Tagging'.

	categories := model allTagCategories.
	categories do: [ :cat | 
		tags := cat markedTags.
		tags ifNotEmpty: [ 
			groupCat := CmCommandGroup new.
			groupCat name: cat name.

			tags do: [ :c | 
				| command |
				command := self forSpecContext: aPresenter.
				command name: c name.
				(element isTaggedWith: c)
					ifTrue: [ command decoratedCommand forRemoval ]
					ifFalse: [ command decoratedCommand forAdding ].
				command decoratedCommand tag: c.
				groupCat register: command ].
			group register: groupCat asSpecGroup ] ].
	rootCommandGroup register: group asSpecGroup
]

{ #category : #'accessing - defaults' }
MiTagEntity class >> canBeExecutedOn: anObject [

	^ anObject isKindOf: MooseEntity
]

{ #category : #'accessing - defaults' }
MiTagEntity class >> defaultName [
	^ '?'
]

{ #category : #'property - generated' }
MiTagEntity >> canBeExecuted [

	^ self class canBeExecutedOn: self context miSelectedItem
]

{ #category : #'property - generated' }
MiTagEntity >> execute [

	removal
		ifTrue: [ self context miSelectedItem removeTag: tag ]
		ifFalse: [ self context miSelectedItem tagWith: tag ]
]

{ #category : #'property - generated' }
MiTagEntity >> forAdding [
	removal := false. 
]

{ #category : #'property - generated' }
MiTagEntity >> forRemoval [
	removal := true. 
]

{ #category : #'property - generated' }
MiTagEntity >> name [

	^ (removal
		   ifTrue: [ #- ]
		   ifFalse: [ #+ ]) , ' ' , super name
]

{ #category : #'property - generated' }
MiTagEntity >> tag: aFamixTag [

	tag := aFamixTag
]
