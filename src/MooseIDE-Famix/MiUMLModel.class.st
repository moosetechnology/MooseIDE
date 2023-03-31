Class {
	#name : #MiUMLModel,
	#superclass : #MiAbstractModel,
	#instVars : [
		'entities',
		'selected'
	],
	#category : #'MooseIDE-Famix-UML'
}

{ #category : #accessing }
MiUMLModel >> entities [

	^ entities
]

{ #category : #accessing }
MiUMLModel >> entities: anObject [

	entities := anObject
]

{ #category : #accessing }
MiUMLModel >> selected [

	^ selected
]

{ #category : #accessing }
MiUMLModel >> selected: anObject [

	selected := anObject
]

{ #category : #'api - selection' }
MiUMLModel >> unselectAll [

	selected := nil
]
