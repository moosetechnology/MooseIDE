Class {
	#name : #MiSystemComplexityVisualization,
	#superclass : #MiAbstractHierarchicalVisualization,
	#category : #'MooseIDE-Visualization-System Complexity'
}

{ #category : #initialization }
MiSystemComplexityVisualization >> buildInCanvas: canvas [

	self model ifNil: [ ^ self ].

	builder := MiSystemComplexityBuilder new
		           container: canvas;
		           mapModel: self model;
		           yourself.

	builder build.

	^ canvas @ RSCanvasController new noLegend
]

{ #category : #initialization }
MiSystemComplexityVisualization >> initialize [

	super initialize.

	self script: [ :canvas | self buildInCanvas: canvas ]
]

{ #category : #accessing }
MiSystemComplexityVisualization >> model [

	^ self owner model
]
