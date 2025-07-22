Class {
	#name : 'MiMultiLayerStrategy',
	#superclass : 'MiAbstractDisplayStrategy',
	#category : 'MooseIDE-LayerVisualization-Strategy',
	#package : 'MooseIDE-LayerVisualization',
	#tag : 'Strategy'
}

{ #category : 'filtering' }
MiMultiLayerStrategy >> fetchViolatingDaos [

	^ self subclassResponsibility 
]

{ #category : 'filtering' }
MiMultiLayerStrategy >> fetchViolatingServers [
	
	^ self subclassResponsibility
]

{ #category : 'filtering' }
MiMultiLayerStrategy >> fetchViolatingServices [

	^ self subclassResponsibility
]

{ #category : 'filtering' }
MiMultiLayerStrategy >> fetchViolatingTransverse [

	^ self subclassResponsibility
]
