Class {
	#name : #MiTagTree,
	#superclass : #MiTreeWidget,
	#instVars : [
		'mooseModel'
	],
	#category : #'MooseIDE-Tagging-Manager'
}

{ #category : #specs }
MiTagTree class >> buildCommandsGroupWith: presenterInstance forRoot: rootCommandGroup [

	super
		buildCommandsGroupWith: presenterInstance
		forRoot: rootCommandGroup.


	rootCommandGroup register:
		(MiAddTagCommand forSpecContext: presenterInstance).
	rootCommandGroup register:
		(MiRemoveTagCommand forSpecContext: presenterInstance).

	rootCommandGroup register:
		(MiRemoveTagCategoryCommand forSpecContext: presenterInstance).
	rootCommandGroup register:
		(MiAddTagCategoryCommand forSpecContext: presenterInstance).
	rootCommandGroup register:
		(MiRenameTagCategoryCommand forSpecContext: presenterInstance)
]

{ #category : #accessing }
MiTagTree class >> open [

	<example>
	super open
]

{ #category : #accessing }
MiTagTree class >> title [
	^ 'Tags'
]

{ #category : #visiting }
MiTagTree >> accept: anEntity [

	^ anEntity isKindOf: MooseModel
]

{ #category : #opening }
MiTagTree >> childrenFor: anEntry [

	(anEntry isKindOf: FamixTagCategory) ifTrue: [ ^ anEntry markedTags ].
	(anEntry isKindOf: FamixTag) ifTrue: [ ^ anEntry subTags ].
	self error: 'Unexpected entry ' , anEntry class name
]

{ #category : #opening }
MiTagTree >> followAction [

	mooseModel := toSelect.
	self refresh 
]

{ #category : #opening }
MiTagTree >> mooseModel [

	^ mooseModel
]

{ #category : #opening }
MiTagTree >> refresh [

	| cats |
	cats := mooseModel allTagCategories.

	tree items: (cats ifEmpty: [ { 'empty' } ] ifNotEmpty: [ cats ])
]
