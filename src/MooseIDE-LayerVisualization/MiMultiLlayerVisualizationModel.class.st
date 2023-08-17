Class {
	#name : #MiMultiLlayerVisualizationModel,
	#superclass : #MiLayerVisualizationModel,
	#instVars : [
		'daoTag',
		'implAndIntViolation',
		'serviceTag',
		'serviceLayer',
		'daoLayer',
		'serverLayersToDisplay',
		'serviceLayerToDisplay',
		'daoLayerToDisplay',
		'transverseLayer',
		'transverseLayerToDisplay'
	],
	#category : #'MooseIDE-LayerVisualization-Model'
}

{ #category : #initialization }
MiMultiLlayerVisualizationModel class >> queriesHolder [

	^ MiEvoQueriesHolder
]

{ #category : #adding }
MiMultiLlayerVisualizationModel >> addDependenciesFrom: sourcesLayer to: targetsLayer execute: aBlock [

	sourcesLayer do: [ :class | 
		(self classDependenciesFor: class) do: [ :dc | 
			(targetsLayer includes: dc) ifTrue: [
				self addDependency: dc in: incomingCache for: class.
				self addDependency: class in: outgoingCache for: dc.
				aBlock value: class value: dc ] ] ]
]

{ #category : #adding }
MiMultiLlayerVisualizationModel >> addDependenciesToDaoAndTag [

	self
		addDependenciesFrom: (self serverLayers at: 1)
		to: daoLayer
		execute: [ :impl :dao | 
			dao tagWith: daoTag.
			impl tagWith: implAndIntViolation ].

	daoLayer do: [ :class | 
		(self classDependenciesFor: class) do: [ :d | 
			(serviceLayer includes: d) ifTrue: [ 
				self addDependency: d in: incomingCache for: class.
				self addDependency: class in: outgoingCache for: d ] ] ].


	serviceLayer do: [ :class | 
		(self classDependenciesFor: class) do: [ :d | 
			((self serverLayers at: 1) includes: d) ifTrue: [ 
				self addDependency: d in: incomingCache for: class.
				self addDependency: class in: outgoingCache for: d ] ] ]
]

{ #category : #adding }
MiMultiLlayerVisualizationModel >> addDependenciesToServicesAndTag [

	self
		addDependenciesFrom: (self serverLayers at: 1)
		to: serviceLayer
		execute: [ :impl :service | 
			(service hasTag: serviceTag) ifFalse: [ 
				service tagWith: serviceTag ] ]
]

{ #category : #adding }
MiMultiLlayerVisualizationModel >> addLayer [

	| allNewSClasses |
	allNewSClasses := self addCacheServerDependencies.
	serverLayers add: (allNewSClasses reject: [ :c | 
			 (serviceLayer includes: c) or: [ 
				 (daoLayer includes: c) or: [ transverseLayer includes: c ] ] ]).
	self setServerClasses.

	index := index + 1
]

{ #category : #building }
MiMultiLlayerVisualizationModel >> buildDaoLayer [

	daoLayerToDisplay := displayStrategy fetchViolatingDaos.
	^ MiLVFlowBoxNode new
		  dashedBorder;
		  name: 'Dao: ' , daoLayerToDisplay size asString , '/'
			  , daoLayer size asString , ' classes';
		  gapSize: 80;
		  addAll: (self entitiesOf: daoLayerToDisplay);
		  yourself
]

{ #category : #building }
MiMultiLlayerVisualizationModel >> buildDescription [

	description := MiLVVerticalBoxNode new
		               withoutBorder;
		               gapSize: 90;
		               add: self buildTransverseLayer;
		               add: (MiLVHorizontalBoxNode new
				                withoutBorder;
				                gapSize: 90;
				                add: self buildUCLayer;
				                add: self buildServiceLayer;
				                add: self buildDaoLayer;
				                yourself);
		               yourself.
	^ description
]

{ #category : #building }
MiMultiLlayerVisualizationModel >> buildServiceLayer [

	serviceLayerToDisplay := displayStrategy fetchViolatingServices.
	^ MiLVFlowBoxNode new
		  dashedBorder;
		  name: 'Service: ' , serviceLayerToDisplay size asString , '/'
			  , serviceLayer size asString , ' classes';
		  gapSize: 80;
		  addAll: (self entitiesOf: serviceLayerToDisplay);
		  yourself
]

{ #category : #building }
MiMultiLlayerVisualizationModel >> buildTransverseLayer [

	transverseLayerToDisplay := displayStrategy fetchViolatingTransverse .
	^ MiLVFlowBoxNode new
		  dashedBorder;
		  name: 'Transverse: ' , transverseLayerToDisplay size asString , '/'
			  , transverseLayer size asString , ' classes';
		  gapSize: 80;
		  addAll: (self entitiesOf: transverseLayerToDisplay);
		  yourself
]

{ #category : #building }
MiMultiLlayerVisualizationModel >> buildUCLayer [

	^ MiLVHorizontalBoxNode new
		  dashedBorder;
		  name: 'UC';
		  gapSize: 80;
		  addAll: self buildUCLayers;
		  yourself
]

{ #category : #building }
MiMultiLlayerVisualizationModel >> buildUCLayers [

	^ (serverLayersToDisplay := displayStrategy fetchViolatingServers) 
		  collectWithIndex: [ :layer :i | 
			  MiLVFlowBoxNode new
				  dashedBorder;
				  name:
					  layer size asString , '/' , (serverLayers at: i) size asString
					  , ' classes';
				  addAll: (self entitiesOf: layer);
				  yourself ]
]

{ #category : #partitioning }
MiMultiLlayerVisualizationModel >> checkIsImplementationOrService: aClass [
	^ self checkIsImplementation: aClass 
]

{ #category : #building }
MiMultiLlayerVisualizationModel >> createLinksFromDAOIn: hNodeDict [

	| serverLayer |
	serverLayer := serverLayersToDisplay flatten asSet.
	daoLayerToDisplay do: [ :dao | 
		| hn |
		hn := hNodeDict at: dao.

		"Create links between DAO layer and service layer, in that direction."
		((self classDependenciesFor: dao) select: [ :d | 
			 (serviceLayerToDisplay includes: d) or: [ serverLayer includes: d ] ]) 
			do: [ :dc | 
				| dhn |
				dhn := hNodeDict at: dc.
				hn dependencyTo: dhn ].
		"Create links between UC layer and DAO layer, in that direction."
		((self classDependantsFor: dao) select: [ :d | 
			 serverLayer includes: d ]) do: [ :dc | 
			| dhn |
			dhn := hNodeDict at: dc.
			dhn dependencyTo: hn ] ]
]

{ #category : #building }
MiMultiLlayerVisualizationModel >> createLinksFromServiceIn: hNodeDict [
	"Create links between service layer and uc layer, in that direction."
	serviceLayerToDisplay do: [ :service | 
		| hn |
		hn := hNodeDict at: service.
		((self classDependenciesFor: service) select: [ :d | 
			 serverLayersToDisplay flatten includes: d ]) do: [ :dc | 
			| dhn |
			dhn := hNodeDict at: dc.
			hn dependencyTo: dhn ] ]
]

{ #category : #building }
MiMultiLlayerVisualizationModel >> createLinksFromTransverseIn: hNodeDict [
	"Create links between traverse layer and uc, service or dao layer, in that direction."
	transverseLayerToDisplay do: [ :traverse | 
		| hn |
		hn := hNodeDict at: traverse.
		((self classDependenciesFor: traverse) select: [ :d | 
			 (serverLayersToDisplay flatten includes: d) or: [ 
				 (serviceLayerToDisplay includes: d) or: [ 
					 daoLayerToDisplay includes: d ] ] ]) do: [ :dc | 
			| dhn |
			dhn := hNodeDict at: dc.
			hn dependencyTo: dhn ] ]
]

{ #category : #building }
MiMultiLlayerVisualizationModel >> createLinksIn: hNodeDict [

	"The hNodeDict is a dictionary containing hnodes as values and famix classes as keys."

	self createLinksFromDAOIn: hNodeDict.
	self createLinksFromServiceIn: hNodeDict.
	self createLinksFromTransverseIn: hNodeDict
]

{ #category : #queries }
MiMultiLlayerVisualizationModel >> dao [

	^ queriesHolder daos result
]

{ #category : #accessing }
MiMultiLlayerVisualizationModel >> daoLayer [

	^ daoLayer
]

{ #category : #queries }
MiMultiLlayerVisualizationModel >> eServices [

	^ queriesHolder eServices result
]

{ #category : #adding }
MiMultiLlayerVisualizationModel >> initialize [

	super initialize.
	daoLayer := Set new.
	serviceLayer := Set new.
	transverseLayer := Set new.
	displayStrategy := MiFilterMultiLayerViolationStrategy new
		                   visualizationModel: self;
		                   yourself
]

{ #category : #adding }
MiMultiLlayerVisualizationModel >> initializeFirstServerLayer [

	self serverLayers add: Dictionary new.
	self serverLayers
		at: 1
		put: queriesHolder serviceImplementations result
]

{ #category : #adding }
MiMultiLlayerVisualizationModel >> initializeOtherLayers [

	daoTag := (self mooseModel tagNamed: 'daoViolation')
		          color: (Color fromHexString: 'B2182B');
		          yourself.
	implAndIntViolation := self mooseModel tagNamed:
		                       'implAndIntViolation'.
	serviceTag := (self mooseModel tagNamed: 'serviceNoViolation')
		              color: (Color fromHexString: 'EF8A62');
		              yourself.
	self eServices do: [ :c | serviceLayer add: c ].
	self dao do: [ :c | daoLayer add: c ].
	self transverse do: [ :c | transverseLayer add: c ]
]

{ #category : #adding }
MiMultiLlayerVisualizationModel >> initializePartitioning [

	self initializeFirstServerLayer.
	self initializeOtherLayers.
	self addDependenciesToDaoAndTag.
	self addDependenciesToServicesAndTag.
	index := 1
]

{ #category : #testing }
MiMultiLlayerVisualizationModel >> serverLayersIncludes: aClass [

	serverLayers do: [ :layer | 
		(layer includes: aClass) ifTrue: [ ^ true ] ].
	^ false
]

{ #category : #accessing }
MiMultiLlayerVisualizationModel >> serviceLayer [

	^ serviceLayer
]

{ #category : #queries }
MiMultiLlayerVisualizationModel >> transverse [

	^ queriesHolder transverse result
]

{ #category : #accessing }
MiMultiLlayerVisualizationModel >> transverseLayer [

	^ transverseLayer
]
