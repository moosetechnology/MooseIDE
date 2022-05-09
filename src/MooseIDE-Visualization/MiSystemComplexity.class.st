Class {
	#name : #MiSystemComplexity,
	#superclass : #MiAbstractVisualization,
	#instVars : [
		'types'
	],
	#category : #'MooseIDE-Visualization'
}

{ #category : #running }
MiSystemComplexity >> run [

	super run.
	self script: [ :canvas | 
		| builder |
		builder := types systemComplexity.
		builder canvas: canvas.
		builder build.
		canvas @ RSCanvasController new noLegend ]
]

{ #category : #accessing }
MiSystemComplexity >> types [

	^ types
]

{ #category : #accessing }
MiSystemComplexity >> types: anObject [

	types := anObject
]
