"
I am a roassal presenter for the MiLayerVisualizationBrowser.
I have a canvas and I use a builder (MiLayerVisualizationBuilder).
"
Class {
	#name : #MiLayerVisualization,
	#superclass : #MiAbstractHierarchicalVisualization,
	#category : #'MooseIDE-LayerVisualization-Presenters'
}

{ #category : #initialization }
MiLayerVisualization >> buildInCanvas: aCanvas [

	owner model ifNil: [ ^ self ].

	builder := MiLayerVisualizationBuilder new
		           mapModel: owner model;
		           container: aCanvas;
		           yourself.

	builder build
]

{ #category : #initialization }
MiLayerVisualization >> initialize [

	super initialize.

	self script: [ :canvas | self buildInCanvas: canvas ]
]
