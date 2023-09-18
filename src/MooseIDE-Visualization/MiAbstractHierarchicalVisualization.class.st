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

{ #category : #highlighting }
MiAbstractHierarchicalVisualization >> highlightShapes [

	self selectShapes:
		(self shapesWithModel: [ :shape | shape model rawModel ])
]

{ #category : #accessing }
MiAbstractHierarchicalVisualization >> miSelectedItem [

	^ self canvas selectedShapes collect: [ :shape |
		  shape model rawModel ]
]
