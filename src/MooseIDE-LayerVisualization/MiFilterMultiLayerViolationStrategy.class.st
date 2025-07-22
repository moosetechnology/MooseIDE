Class {
	#name : 'MiFilterMultiLayerViolationStrategy',
	#superclass : 'MiMultiLayerStrategy',
	#category : 'MooseIDE-LayerVisualization-Strategy',
	#package : 'MooseIDE-LayerVisualization',
	#tag : 'Strategy'
}

{ #category : 'filtering' }
MiFilterMultiLayerViolationStrategy >> fetchViolatingDaos [

	^ visualizationModel daoLayer select: [ :dao | 
		  ((visualizationModel classDependenciesFor: dao) anySatisfy: [ :c | 
			   (visualizationModel serviceLayer includes: c) or: [ 
				   visualizationModel serverLayers flatten includes: c ] ]) or: [ 
			  (visualizationModel classDependantsFor: dao) anySatisfy: [ :c | 
				  visualizationModel serverLayers flatten includes: c ] ] ]
]

{ #category : 'filtering' }
MiFilterMultiLayerViolationStrategy >> fetchViolatingServers [

	^ visualizationModel serverLayers collect: [ :layer | 
		  layer select: [ :server | 
			  (self serverHasDirectLinkWithDAO: server) or: [ 
				  self serverHasDirectLinkFromService: server ] ] ]
]

{ #category : 'filtering' }
MiFilterMultiLayerViolationStrategy >> fetchViolatingServices [

	^ visualizationModel serviceLayer select: [ :service | 
		  ((visualizationModel classDependantsFor: service) anySatisfy: [ :c | 
			   visualizationModel daoLayer includes: c ]) or: [ 
			  (visualizationModel classDependenciesFor: service) anySatisfy: [ 
				  :c | visualizationModel serverLayersIncludes: c ] ] ]
]

{ #category : 'filtering' }
MiFilterMultiLayerViolationStrategy >> fetchViolatingTransverse [

	^ visualizationModel transverseLayer select: [ :transverse | 
		  (visualizationModel classDependenciesFor: transverse) anySatisfy: [ 
			  :c | 
			  (visualizationModel daoLayer includes: c) or: [ 
				  (visualizationModel serverLayersIncludes: c) or: [ 
					  visualizationModel serviceLayer includes: c ] ] ] ]
]

{ #category : 'filtering' }
MiFilterMultiLayerViolationStrategy >> serverHasDirectLinkFromService: aServerClass [

	| testBlock |
	testBlock := [ :c | 
	             | actualClass |
	             actualClass := visualizationModel rootClass: c.
	             (visualizationModel serviceLayer includes: c) ifTrue: [ 
		             ^ true ] ].
	aServerClass allClients do: testBlock.


	^ false
]

{ #category : 'filtering' }
MiFilterMultiLayerViolationStrategy >> serverHasDirectLinkWithDAO: aServerClass [

	| testBlock |
	testBlock := [ :c | 
	             | actualClass |
	             actualClass := visualizationModel rootClass: c.
	             (visualizationModel daoLayer includes: c) ifTrue: [ 
		             ^ true ] ].
	aServerClass allClients do: testBlock.
	aServerClass allProviders do: testBlock.


	^ false
]
