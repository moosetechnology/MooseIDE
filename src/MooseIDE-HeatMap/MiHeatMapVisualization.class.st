Class {
	#name : 'MiHeatMapVisualization',
	#superclass : 'MiAbstractHierarchicalVisualization',
	#category : 'MooseIDE-HeatMap',
	#package : 'MooseIDE-HeatMap'
}

{ #category : 'running' }
MiHeatMapVisualization >> buildInCanvas: aCanvas [

	owner specModel entities ifNil: [ ^ self ].
	builder := MiHeatMapBuilder new
		           mapModel: owner specModel;
		           container: aCanvas;
		           yourself.

	builder build.
	builder rootNode expandChildren.

	aCanvas @ RSCanvasController new noLegend
]
