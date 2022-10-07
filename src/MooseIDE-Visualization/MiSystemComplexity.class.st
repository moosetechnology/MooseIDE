Class {
	#name : #MiSystemComplexity,
	#superclass : #MiAbstractVisualization,
	#category : #'MooseIDE-Visualization'
}

{ #category : #accessing }
MiSystemComplexity >> model [

	^ self owner model
]

{ #category : #running }
MiSystemComplexity >> run [

	super run.
	self script: [ :canvas | 
		| builder |
		builder := MiSystemComplexityBuilder new
			           container: canvas;
			           mapModel: self model;
			           yourself.
		builder build.
		canvas @ RSCanvasController new noLegend ]
]
