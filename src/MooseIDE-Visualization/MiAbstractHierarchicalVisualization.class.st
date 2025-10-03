Class {
	#name : 'MiAbstractHierarchicalVisualization',
	#superclass : 'MiAbstractVisualization',
	#instVars : [
		'builder'
	],
	#category : 'MooseIDE-Visualization-Helpers',
	#package : 'MooseIDE-Visualization',
	#tag : 'Helpers'
}

{ #category : 'accessing' }
MiAbstractHierarchicalVisualization >> builder [

	^ builder
]

{ #category : 'accessing' }
MiAbstractHierarchicalVisualization >> builder: anObject [

	builder := anObject
]

{ #category : 'accessing' }
MiAbstractHierarchicalVisualization >> modelForShape: aShape [

	^ aShape model rawModel
]
