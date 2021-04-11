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
MiTagBrowserModel >> addTag: aName [

	^self mooseModel tagNamed: aName
]

{ #category : #accessing }
MiTagBrowserModel >> allTags [

	^self mooseModel allTags
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
MiTagBrowserModel >> deleteCurrentTag [
	self mooseModel remove: currentTag
]

{ #category : #accessing }
MiTagBrowserModel >> entitiesTaggedWithCurrentTag [
	self mooseModel ifNil: [ #() ].
	self currentTag ifNil: [ #() ].
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
MiTagBrowserModel >> tagEntity: anEntity [
	anEntity tagWith: self currentTag
]

{ #category : #accessing }
MiTagBrowserModel >> untagEntity: anEntity [
	anEntity removeTag: self currentTag
]
