"
I am a roassal presenter for the MiLayerVisualizationBrowser.
I have a canvas and I use a builder (MiLayerVisualizationBuilder).
"
Class {
	#name : #MiLayerVisualization,
	#superclass : #MiAbstractHierarchicalVisualization,
	#category : #'MooseIDE-LayerVisualization-Presenters'
}

{ #category : #accessing }
MiLayerVisualization >> model [

	^ self owner model
]
