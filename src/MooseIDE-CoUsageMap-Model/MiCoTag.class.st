"
TODO
"
Class {
	#name : #MiCoTag,
	#superclass : #Object,
	#instVars : [
		'name',
		'color',
		'description',
		'references'
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
