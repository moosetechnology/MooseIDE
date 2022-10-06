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
		builder := MiSystemComplexityBuilder new
			           container: canvas;
			           types: types;
			           yourself.
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
