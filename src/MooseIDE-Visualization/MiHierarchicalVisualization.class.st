Class {
	#name : #MiHierarchicalVisualization,
	#superclass : #MiAbstractVisualization,
	#instVars : [
		'rootNode',
		'builder'
	],
	#category : #'MooseIDE-Visualization'
}

{ #category : #running }
MiHierarchicalVisualization >> entities: aCollection [

	rootNode children:
		(aCollection collect: [ :entity | HNode new name: entity name ])
]

{ #category : #highlighting }
MiHierarchicalVisualization >> highlightShapes [

]

{ #category : #running }
MiHierarchicalVisualization >> initialize [

	super initialize.
	rootNode := HNode new name: 'Root'.
	builder := HSimpleVisualizationBuilder new
		           rootNode: rootNode;
		           container: self canvas
]

{ #category : #running }
MiHierarchicalVisualization >> run [

	super run.
	builder := HSimpleVisualizationBuilder new
		           rootNode: rootNode;
		           container: self canvas.
	builder build.
	self canvas zoomToFit
]
