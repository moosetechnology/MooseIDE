"
Base of MiCoAttribute and MiCoMethods which are wrapper for the real object from users domain.
Use #rawObject to access to the real object model.
A MiCoTaggedObject receives tags


"
Class {
	#name : #MiCoAbstractBox,
	#superclass : #Object,
	#instVars : [
		'mooseEntity'
	],
	#category : #'MooseIDE-CoUsageMap-Model'
}

{ #category : #accessing }
MiCoAbstractBox >> mooseEntity [
	^ mooseEntity
]

{ #category : #accessing }
MiCoAbstractBox >> mooseEntity: anObject [
	mooseEntity := anObject
]

{ #category : #inspector }
MiCoAbstractBox >> mooseInspect [
	MiInspectorBrowser inspect: self mooseEntity
]

{ #category : #accessing }
MiCoAbstractBox >> name [
	^self mooseEntity name
]

{ #category : #printing }
MiCoAbstractBox >> printOn: s [
	s nextPutAll: self name
]

{ #category : #private }
MiCoAbstractBox >> privateTag: aTag [
	tag := aTag
]

{ #category : #accessing }
MiCoAbstractBox >> tag [
	self flag: 'handle multiple tags'.
	^self mooseEntity allTags
	ifEmpty: [ nil ]
	ifNotEmpty: [ :tags | tags anyOne ]
]

{ #category : #accessing }
MiCoAbstractBox >> type [
	^ self subclassResponsibility
]
