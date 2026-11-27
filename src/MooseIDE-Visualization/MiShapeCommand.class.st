Class {
	#name : 'MiShapeCommand',
	#superclass : 'MiCommand',
	#instVars : [
		'shape',
		'browser'
	],
	#category : 'MooseIDE-Visualization-Commands',
	#package : 'MooseIDE-Visualization',
	#tag : 'Commands'
}

{ #category : 'accessing' }
MiShapeCommand >> browser [

	^ browser
]

{ #category : 'accessing' }
MiShapeCommand >> browser: aMiBrowser [

	browser := aMiBrowser
]

{ #category : 'accessing' }
MiShapeCommand >> shape [

	^ shape
]

{ #category : 'accessing' }
MiShapeCommand >> shape: aShape [

	shape := aShape
]
