"
Butterfly visualization.
"
Class {
	#name : 'MiButterflyMapVisualization',
	#superclass : 'MiAbstractHierarchicalVisualization',
	#category : 'MooseIDE-ButterflyMap-Browser',
	#package : 'MooseIDE-ButterflyMap',
	#tag : 'Browser'
}

{ #category : 'running' }
MiButterflyMapVisualization >> buildInCanvas: aCanvas [

	owner model currentEntity ifNil: [ ^ self ].
	aCanvas @ RSCanvasController new noLegend. 

	builder := MiButterflyMapBuilder new
		           mapModel: owner model;
		           container: aCanvas;
		           yourself.
	builder build
]

{ #category : 'running' }
MiButterflyMapVisualization >> update [

	self refresh
]
