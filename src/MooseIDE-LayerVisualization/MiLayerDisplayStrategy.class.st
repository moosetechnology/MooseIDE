Class {
	#name : #MiLayerDisplayStrategy,
	#superclass : #MiAbstractDisplayStrategy,
	#category : #'MooseIDE-LayerVisualization-Strategy'
}

{ #category : #filtering }
MiLayerDisplayStrategy >> fetchNotSharedDTOs [

 ^ self subclassResponsibility 
]

{ #category : #filtering }
MiLayerDisplayStrategy >> fetchViolatingClients [

	^ self subclassResponsibility 
]

{ #category : #filtering }
MiLayerDisplayStrategy >> fetchViolatingServers [

	^ self subclassResponsibility
]

{ #category : #filtering }
MiLayerDisplayStrategy >> shouldDisplaySharedDTOs [

	^ self subclassResponsibility
]
