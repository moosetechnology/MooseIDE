"
Base of MiCoAttribute and MiCoMethods which are wrapper for the real object from users domain.
Use #rawObject to access to the real object model.
A MiCoTaggedObject receives tags


"
Class {
	#name : #MiCoAbstractBox,
	#superclass : #Object,
	#instVars : [
		'tag',
		'name',
		'rawObject',
		'application'
	],
	#category : #'MooseIDE-CoUsageMap-Model'
}

{ #category : #inspector }
MiCoAbstractBox >> mooseInspect: anObject [ 
	MiInspectorBrowser inspect: anObject
]

{ #category : #accessing }
MiCoAbstractBox >> name [
	^ name
]

{ #category : #accessing }
MiCoAbstractBox >> name: aString [
	name := aString
]

{ #category : #printing }
MiCoAbstractBox >> printOn: s [
	s nextPutAll: name
]

{ #category : #private }
MiCoAbstractBox >> privateTag: aTag [
	tag := aTag
]

{ #category : #accessing }
MiCoAbstractBox >> rawObject [
	^ rawObject
]

{ #category : #accessing }
MiCoAbstractBox >> rawObject: anObject [
	rawObject := anObject
]

{ #category : #accessing }
MiCoAbstractBox >> tag [
	^ tag
]

{ #category : #accessing }
MiCoAbstractBox >> tag: aMiCoTag [
	tag ifNotNil: [ tag removeReference: self ].
	tag := aMiCoTag.
	^tag ifNil: [ nil ] ifNotNil: [ tag addReference: self ]
]

{ #category : #accessing }
MiCoAbstractBox >> type [
	^ self subclassResponsibility
]
