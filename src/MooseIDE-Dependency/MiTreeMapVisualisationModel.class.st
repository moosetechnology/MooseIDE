Class {
	#name : #MiTreeMapVisualisationModel,
	#superclass : #MiAbstractModel,
	#instVars : [
		'entities'
	],
	#category : #'MooseIDE-Dependency-TreeMap'
}

{ #category : #accessing }
MiTreeMapVisualisationModel >> entities [

	^ entities
]

{ #category : #accessing }
MiTreeMapVisualisationModel >> entities: anObject [

	entities := anObject
]
