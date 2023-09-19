Class {
	#name : #MiAbstractHierarchicalVisualization,
	#superclass : #MiAbstractVisualization,
	#instVars : [
		'builder'
	],
	#category : #'MooseIDE-Visualization-Helpers'
}

{ #category : #accessing }
MiAbstractHierarchicalVisualization >> builder [

	^ builder
]

{ #category : #accessing }
MiAbstractHierarchicalVisualization >> builder: anObject [

	builder := anObject
]

{ #category : #'as yet unclassified' }
MiAbstractHierarchicalVisualization >> modelForShape: aShape [

	^ aShape model rawModel
]
