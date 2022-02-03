"
TODO
"
Class {
	#name : #MiCoTaggedObject,
	#superclass : #Object,
	#instVars : [
		'tag',
		'name',
		'rawObject',
		'application'
	],
	#category : #'MooseIDE-CoUsageMap-Model'
}

{ #category : #accessing }
MiCoTaggedObject >> application [
	^ application
]

{ #category : #accessing }
MiCoTaggedObject >> application: anObject [
	application := anObject
]

{ #category : #accessing }
MiCoTaggedObject >> name [
	^ name
]

{ #category : #accessing }
MiCoTaggedObject >> name: aString [
	name := aString
]

{ #category : #printing }
MiCoTaggedObject >> printOn: s [
	s nextPutAll: name
]

{ #category : #accessing }
MiCoTaggedObject >> rawObject [

	^ rawObject
]

{ #category : #accessing }
MiCoTaggedObject >> rawObject: anObject [

	rawObject := anObject
]

{ #category : #accessing }
MiCoTaggedObject >> tag [
	^ tag
]

{ #category : #accessing }
MiCoTaggedObject >> tag: aMiCoTag [
	tag ifNotNil: [ tag removeReference: self ].
	tag := aMiCoTag.
	tag ifNotNil: [ tag addReference: self ].
	
]
