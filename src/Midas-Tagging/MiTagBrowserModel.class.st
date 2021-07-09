Class {
	#name : #MiTagBrowserModel,
	#superclass : #Object,
	#instVars : [
		'currentTag',
		'owner',
		'mooseModel',
		'logger'
	],
	#category : #'Midas-Tagging'
}

{ #category : #accessing }
MiTagBrowserModel >> addCategory: aName [

]

{ #category : #accessing }
MiTagBrowserModel >> addTag: aName [

	^self mooseModel tagNamed: aName
]

{ #category : #accessing }
MiTagBrowserModel >> allCategories [
	^#( '*Not implemented yet*' )
]

{ #category : #accessing }
MiTagBrowserModel >> allTags [

	^self mooseModel
		ifNil: [ #() ]
		ifNotNil: [ :model | model allTags ]
]

{ #category : #accessing }
MiTagBrowserModel >> currentCategory [
	^ nil
]

{ #category : #accessing }
MiTagBrowserModel >> currentCategory: anObject [

]

{ #category : #accessing }
MiTagBrowserModel >> currentTag [

	^ currentTag
]

{ #category : #accessing }
MiTagBrowserModel >> currentTag: anObject [
	currentTag := anObject.
	owner newTagSelected
]

{ #category : #accessing }
MiTagBrowserModel >> deleteCurrentCategory [

]

{ #category : #accessing }
MiTagBrowserModel >> deleteCurrentTag [
	currentTag remove.
	self currentTag: nil
]

{ #category : #accessing }
MiTagBrowserModel >> entitiesTaggedWithCurrentTag [
	self mooseModel ifNil: [ ^#() ].
	self currentTag ifNil: [ ^#() ].
	^self mooseModel entitiesTaggedWith: self currentTag
]

{ #category : #accessing }
MiTagBrowserModel >> logger [

	^ logger
]

{ #category : #accessing }
MiTagBrowserModel >> logger: anObject [
	logger := anObject
]

{ #category : #accessing }
MiTagBrowserModel >> mooseModel [
	^mooseModel ifNil: [
		mooseModel := self mostRecentModel
	]
]

{ #category : #accessing }
MiTagBrowserModel >> mooseModel: aModel [
	mooseModel := aModel
]

{ #category : #accessing }
MiTagBrowserModel >> mostRecentEntity [
	^ self logger mostRecentEntity
]

{ #category : #accessing }
MiTagBrowserModel >> mostRecentModel [
	^self logger mostRecentEntity
		ifNil: [  MooseModel new ]
		ifNotNil: [ :entity | entity mooseModel ]
]

{ #category : #accessing }
MiTagBrowserModel >> owner [

	^ owner
]

{ #category : #accessing }
MiTagBrowserModel >> owner: anObject [

	owner := anObject
]

{ #category : #accessing }
MiTagBrowserModel >> tagEntityNotYourself: anEntity [
	self currentTag = anEntity
	ifFalse: [self currentTag tagEntity: anEntity]
]

{ #category : #accessing }
MiTagBrowserModel >> untagEntity: anEntity [
	anEntity removeTag: self currentTag
]
