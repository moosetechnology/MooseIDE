Class {
	#name : #MiFilterViolationStrategy,
	#superclass : #MiLayerDisplayStrategy,
	#category : #'MooseIDE-LayerVisualization-Strategy'
}

{ #category : #filtering }
MiFilterViolationStrategy >> fetchNotSharedDTOs [

	| shared clientLayers serverLayers incomingCache dict clientProviders serverProviders rootClassBlock |
	shared := visualizationModel sharedLayer.
	clientLayers := visualizationModel clientLayers asSet
		                flatten.
	serverLayers := visualizationModel serverLayers asSet
		                flatten.
	incomingCache := visualizationModel incomingCache.
	dict := Dictionary new.
	dict at: #client put: OrderedCollection new.
	dict at: #server put: OrderedCollection new.
	dict at: #shared put: OrderedCollection new.
	dict at: #nothing put: OrderedCollection new.
	rootClassBlock := [ :c | visualizationModel classDependenciesFor: c ].
	clientProviders := clientLayers flatCollectAsSet: rootClassBlock.
	serverProviders := serverLayers flatCollectAsSet: rootClassBlock.
	shared do: [ :dto | 
		(clientProviders like: dto)
			ifNotNil: [ 
				(serverProviders like: dto)
					ifNotNil: [ self addDto: dto in: dict atKey: #shared ]
					ifNil: [ self addDto: dto in: dict atKey: #client ] ]
			ifNil: [ 
				(serverProviders like: dto)
					ifNotNil: [ self addDto: dto in: dict atKey: #server ]
					ifNil: [ self addDto: dto in: dict atKey: #nothing ] ] ].

	^ dict
]

{ #category : #filtering }
MiFilterViolationStrategy >> fetchViolating: layers [

	| outgoingCache incomingCache |
	outgoingCache := visualizationModel outgoingCache.
	incomingCache := visualizationModel incomingCache.


	^ layers collect: [ :sl | 
		  sl selectAsSet: [ :c | 
			  | in out |
			  out := outgoingCache at: c ifAbsent: [ OrderedCollection new ].
			  in := incomingCache at: c ifAbsent: [ OrderedCollection new ].
			  ((visualizationModel classDependenciesFor: c) anySatisfy: [ :pps | 
				   visualizationModel sharedLayer includes: pps ]) or: [ 
				  out , in anySatisfy: [ :p | 
					  (visualizationModel purgatoryLayer includes: p) or: [ 
						  visualizationModel sharedLayer includes: p ] ] ] ] ]
]

{ #category : #filtering }
MiFilterViolationStrategy >> fetchViolatingClients [


	^ self fetchViolating:  visualizationModel clientLayers 
]

{ #category : #filtering }
MiFilterViolationStrategy >> fetchViolatingServers [

	^ self fetchViolating: visualizationModel serverLayers
]

{ #category : #filtering }
MiFilterViolationStrategy >> shouldDisplaySharedDTOs [

	^ false
]
