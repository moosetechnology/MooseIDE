Class {
	#name : #MiSystemComplexityVisualization,
	#superclass : #MiAbstractHierarchicalVisualization,
	#category : #'MooseIDE-Visualization-System Complexity'
}

{ #category : #running }
MiSystemComplexityVisualization >> buildInCanvas: canvas [

	self specModel ifNil: [ ^ self ].

	builder := MiSystemComplexityBuilder new
		           container: canvas;
		           mapModel: self specModel;
		           yourself.

	builder build.

	^ canvas @ RSCanvasController new noLegend
]

{ #category : #accessing }
MiSystemComplexityVisualization >> specModel [

	^ self owner specModel
]
