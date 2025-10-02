Class {
	#name : 'MiLayerVisualizationModel',
	#superclass : 'MiAbstractModel',
	#instVars : [
		'mooseModel',
		'queriesHolder',
		'description',
		'index',
		'continueClient',
		'continueServer',
		'clientLayers',
		'purgatoryLayer',
		'serverLayers',
		'sharedLayer',
		'incomingCache',
		'outgoingCache',
		'serverClasses',
		'displayStrategy'
	],
	#category : 'MooseIDE-LayerVisualization-Model',
	#package : 'MooseIDE-LayerVisualization',
	#tag : 'Model'
}

{ #category : 'as yet unclassified' }
MiLayerVisualizationModel class >> findModelApplicableTo: aMooseModel [

	self subclassesDo: [ :modelClass | 
		(modelClass queriesHolder canBeAppliedOnModel: aMooseModel) ifTrue: [ 
			^ modelClass ] ].
	^ nil
]

{ #category : 'as yet unclassified' }
MiLayerVisualizationModel class >> queriesHolder [

	self subclassResponsibility
]

{ #category : 'adding' }
MiLayerVisualizationModel >> addCacheServerDependencies [

	^ (serverLayers at: index) flatCollectAsSet: [ :class | 
		  (self classDependenciesFor: class) select: [ :dc | 
			  | exits |
			  exits := incomingCache includesKey: dc.
			  self addDependency: dc in: outgoingCache for: class.
			  self addDependency: class in: incomingCache for: dc.
			  (self checkIsImplementationOrService: dc) not and: [ exits not ] ] ]
]

{ #category : 'partitioning' }
MiLayerVisualizationModel >> addDependency: valueEntity in: aDictionary for: keyEntity [

	aDictionary
		at: keyEntity
		ifPresent: [ :collection | collection add: valueEntity ]
		ifAbsentPut: [ OrderedCollection with: valueEntity ]
]

{ #category : 'testing' }
MiLayerVisualizationModel >> checkIsImplementation: aFamixJavaClass [

	^ (self serverLayers at: 1) includes: aFamixJavaClass
]

{ #category : 'partitioning' }
MiLayerVisualizationModel >> checkIsImplementationOrService: aClass [
 self subclassResponsibility 
]

{ #category : 'partitioning' }
MiLayerVisualizationModel >> classDependantsFor: aClass [

	^ ((aClass queryAllIncoming withoutSelfLoops reject: [ :a | 
		    (a target isCollection
			     ifTrue: [ a target first ]
			     ifFalse: [ a target ]) isStub ]) collect: [ :e | 
		   self rootClass: e source ]) asSet
]

{ #category : 'partitioning' }
MiLayerVisualizationModel >> classDependenciesFor: aClass [

	^ (aClass allProviders
		  reject: [ :c | c isStub ]
		  thenCollect: [ :e | self rootClass: e ]) asSet
]

{ #category : 'accessing' }
MiLayerVisualizationModel >> clientLayers [

	^ clientLayers
]

{ #category : 'accessing' }
MiLayerVisualizationModel >> commonPackagesFor: elements [

	| groups |
	groups := (elements groupedBy: [ :e | (e containersOfType: FamixTPackage) anyOne ]) associations.

	^ groups collect: [ :a | self createPackageElement: a key with: a value ]
]

{ #category : 'building' }
MiLayerVisualizationModel >> createLinksIn: hNodeDict [

	self subclassResponsibility
]

{ #category : 'accessing' }
MiLayerVisualizationModel >> createPackageElement: famixPackage with: elements [

	^ MiLVPackageElement new
		  model: famixPackage;
		  children: (self createTypeElementsFor: elements);
		  yourself
]

{ #category : 'accessing' }
MiLayerVisualizationModel >> createTypeElementsFor: aCollectionOfMooseEntities [

	^ aCollectionOfMooseEntities collect: [ :me | 
		  MiLVTypeElement new
			  model: me;
			  yourself ]
]

{ #category : 'accessing' }
MiLayerVisualizationModel >> entities [

	^ nil
]

{ #category : 'building' }
MiLayerVisualizationModel >> entitiesOf: aLayer [

	^ aLayer size > 100
		  ifTrue: [ self commonPackagesFor: aLayer ]
		  ifFalse: [ self createTypeElementsFor: aLayer ]
]

{ #category : 'actions' }
MiLayerVisualizationModel >> followEntity: anEntity [

	self mooseModel: (anEntity isMooseModel
		              ifTrue: [ anEntity ]
		              ifFalse: [ anEntity mooseModel ]).
	
	browser runVisualization.
]

{ #category : 'accessing' }
MiLayerVisualizationModel >> incomingCache [

	^ incomingCache
]

{ #category : 'initialization' }
MiLayerVisualizationModel >> initialize [

	super initialize.
	self initializeSettings.
	incomingCache := Dictionary new.
	outgoingCache := Dictionary new.
	sharedLayer := Set new.
	purgatoryLayer := Set new.
	serverLayers := OrderedCollection new.
	clientLayers := OrderedCollection new.
	queriesHolder := self class queriesHolder new.
]

{ #category : 'accessing' }
MiLayerVisualizationModel >> mooseModel [

	^ mooseModel
]

{ #category : 'accessing' }
MiLayerVisualizationModel >> mooseModel: aMooseModel [

	mooseModel := aMooseModel.
	queriesHolder mooseModel: mooseModel
]

{ #category : 'accessing' }
MiLayerVisualizationModel >> outgoingCache [

	^ outgoingCache
]

{ #category : 'accessing' }
MiLayerVisualizationModel >> purgatoryLayer [

	^ purgatoryLayer
]

{ #category : 'building' }
MiLayerVisualizationModel >> rootClass: anEntity [

	| rootTypes |
	rootTypes := anEntity query containers withProperty: [ :c | c isType and: [ c typeContainer isPackage ] ].

	self flag: 'This should not be empty, if it happens. It means that there is a problem in the model'.
	rootTypes ifEmpty: [ ^ anEntity ].

	^ rootTypes anyOne
]

{ #category : 'accessing' }
MiLayerVisualizationModel >> serverLayers [

	^ serverLayers
]

{ #category : 'initialization' }
MiLayerVisualizationModel >> setServerClasses [ 

	serverClasses := Dictionary new.
	self serverLayers allButFirst doWithIndex: [ :l :i | l do: [:c | serverClasses at: c put: i + 1]  ] .
]

{ #category : 'accessing' }
MiLayerVisualizationModel >> sharedLayer [

	^ sharedLayer
]
