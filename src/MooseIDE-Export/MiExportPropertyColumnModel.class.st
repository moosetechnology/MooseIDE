Class {
	#name : #MiExportPropertyColumnModel,
	#superclass : #MiExportAbstractColumnModel,
	#instVars : [
		'property'
	],
	#category : #'MooseIDE-Export-Browser'
}

{ #category : #'as yet unclassified' }
MiExportPropertyColumnModel class >> forProperty: aFM3Property [

	^ self new
		  name: aFM3Property name;
		  property: aFM3Property;
		  yourself
]

{ #category : #comparing }
MiExportPropertyColumnModel >> = anObject [
	"Answer whether the receiver and anObject represent the same object."

	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	^ property = anObject property and: [ name = anObject name1 ]
]

{ #category : #comparing }
MiExportPropertyColumnModel >> hash [
	"Answer an integer value that is related to the identity of the receiver."

	^ property hash bitXor: name hash
]

{ #category : #testing }
MiExportPropertyColumnModel >> isPropertyColumn [

	^ true
]

{ #category : #accessing }
MiExportPropertyColumnModel >> name1 [

	^ name
]

{ #category : #private }
MiExportPropertyColumnModel >> privatePrintValueFor: anEntity [
	^ anEntity propertyNamed: self property name
]

{ #category : #accessing }
MiExportPropertyColumnModel >> property [

	^ property
]

{ #category : #accessing }
MiExportPropertyColumnModel >> property: anObject [

	property := anObject
]
