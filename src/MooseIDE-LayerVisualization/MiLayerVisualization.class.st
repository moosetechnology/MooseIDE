"
I am a roassal presenter for the MiLayerVisualizationBrowser.
I have a canvas and I use a builder (MiLayerVisualizationBuilder).
"
Class {
	#name : #MiLayerVisualization,
	#superclass : #MiAbstractVisualization,
	#instVars : [
		'builder'
	],
	#category : #'MooseIDE-LayerVisualization-Presenters'
}

{ #category : #highlighting }
MiLayerVisualization >> highlightShapes [
	

	
]

{ #category : #accessing }
MiLayerVisualization >> model [

	^ self owner model
]
