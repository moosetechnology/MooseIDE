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

{ #category : #testing }
MiExportPropertyColumnModel >> isPropertyColumn [

	^ true
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
