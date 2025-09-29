Class {
	#name : #MiNoFilterLayerStrategy,
	#superclass : #MiLayerDisplayStrategy,
	#category : #'MooseIDE-LayerVisualization-Strategy'
}

{ #category : #filtering }
MiNoFilterLayerStrategy >> fetchNotSharedDTOs [

	| dict |
	dict := Dictionary new.
	dict at: #client put: OrderedCollection new.
	dict at: #server put: OrderedCollection new.
	dict at: #shared put: visualizationModel sharedLayer.
	dict at: #nothing put: OrderedCollection new.
	^ dict
]

{ #category : #filtering }
MiNoFilterLayerStrategy >> fetchViolatingClients [

	^ visualizationModel clientLayers
]

{ #category : #filtering }
MiNoFilterLayerStrategy >> fetchViolatingServers [

	^ visualizationModel serverLayers
]

{ #category : #filtering }
MiNoFilterLayerStrategy >> shouldDisplaySharedDTOs [

	^ true
]
