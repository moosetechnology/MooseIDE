"
Abstract calss for wrappers of container entities (eg. methods) and inner entities (eg. attributes)

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
