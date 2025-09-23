Class {
	#name : 'MiShapeCommand',
	#superclass : 'MiCommand',
	#instVars : [
		'shape'
	],
	#category : 'MooseIDE-Visualization-Commands',
	#package : 'MooseIDE-Visualization',
	#tag : 'Commands'
}

{ #category : 'accessing' }
MiShapeCommand >> shape [

	^ shape
]

{ #category : 'accessing' }
MiShapeCommand >> shape: aShape [

	shape := aShape
]
