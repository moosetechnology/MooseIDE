"
I am a visualization, using a builder to draw a distribution map [1] on my canvas.

[1] S. Ducasse, T. Girba and A. Kuhn, ""Distribution Map,"" 2006 22nd IEEE International Conference on Software Maintenance, 2006, pp. 203-212, doi: 10.1109/ICSM.2006.22.
"
Class {
	#name : #MiDistributionMapVisualization,
	#superclass : #MiAbstractHierarchicalVisualization,
	#category : #'MooseIDE-Dependency-DistributionMap'
}

{ #category : #running }
MiDistributionMapVisualization >> buildInCanvas: aCanvas [

	owner model entities ifNil: [ ^ self ].
	builder := MiDistributionMapBuilder new
		           mapModel: owner model;
		           container: aCanvas;
		           yourself.

	builder build.
	builder rootNode expandChildren.

	aCanvas @ RSCanvasController new noLegend
]

{ #category : #initialization }
MiDistributionMapVisualization >> initialize [

	super initialize.

	self script: [ :canvas | self buildInCanvas: canvas ]
]
