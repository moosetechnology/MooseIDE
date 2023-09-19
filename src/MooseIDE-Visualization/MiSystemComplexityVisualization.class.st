Class {
	#name : #MiSystemComplexityVisualization,
	#superclass : #MiAbstractHierarchicalVisualization,
	#category : #'MooseIDE-Visualization-System Complexity'
}

{ #category : #accessing }
MiSystemComplexityVisualization >> model [

	^ self owner model
]

{ #category : #running }
MiSystemComplexityVisualization >> run [

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
