"
A tag is a representation of a new idea, can be used by MiCoAttributes and MiCoMethods
Users can define a new class of tags, but they will rewrite addReference: and removeReference:

"
Class {
	#name : #MiCoTag,
	#superclass : #Object,
	#instVars : [
		'name',
		'color',
		'description',
		'references',
		'isHidden'
	],
	#category : #'MooseIDE-CoUsageMap-Model'
}

{ #category : #'add-remove' }
MiCoTag >> addReference: aMiCoObject [
	references add: aMiCoObject
]

{ #category : #accessing }
MiCoTag >> color [
	^ color
]

{ #category : #accessing }
MiCoTag >> color: aColor [
	color := aColor
]

{ #category : #accessing }
MiCoTag >> description [
	^ description
]

{ #category : #accessing }
MiCoTag >> description: aString [
	description := aString
]

{ #category : #initialization }
MiCoTag >> initialize [
	super initialize.
	references := OrderedCollection new: 5.
	isHidden := false.
]

{ #category : #accessing }
MiCoTag >> isHidden [
	^ isHidden
]

{ #category : #accessing }
MiCoTag >> isHidden: aBoolean [
	isHidden := aBoolean
]

{ #category : #accessing }
MiCoTag >> name [
	^ name
]

{ #category : #accessing }
MiCoTag >> name: aString [
	name := aString
]

{ #category : #public }
MiCoTag >> numberOfReferences [
	^ references size
]

{ #category : #accessing }
MiCoTag >> references [
	^ references
]

{ #category : #'add-remove' }
MiCoTag >> removeReference: aMiCoAttribute [ 
	references remove: aMiCoAttribute
]

{ #category : #public }
MiCoTag >> toggleVisibility [
	isHidden := isHidden not
]
