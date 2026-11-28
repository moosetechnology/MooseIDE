"
A model for the MiDSMBrowser, contains the entities to display, computes the dependencies and the colors to show the cells of the DSM matrix
"
Class {
	#name : 'MiDSMModel',
	#superclass : 'MiAbstractModel',
	#instVars : [
		'graph',
		'nodeColors',
		'orderedNodesX',
		'orderedNodesY',
		'selectedEntities',
		'dependencies',
		'shouldShowSelfDependencies'
	],
	#category : 'MooseIDE-DSM',
	#package : 'MooseIDE-DSM'
}

{ #category : 'settings management' }
MiDSMModel class >> defaultConfiguration [

	^ MiDSMSettingsConfiguration new
		  shouldShowSelfDependencies: self defaultShouldShowSelfDependencies;
		  yourself
]

{ #category : 'default' }
MiDSMModel class >> defaultShouldShowSelfDependencies [

	^ true
]

{ #category : 'testing' }
MiDSMModel >> canFollowEntity: anObject [

	^ anObject isCollection and: [ 
		  anObject allSatisfy: [ :a | 
			  a usesFamixTrait: TEntityMetaLevelDependency ] ].
]

{ #category : 'api' }
MiDSMModel >> colorForTuple: tuple [

	(self isDiagonal: tuple) ifTrue: [ ^self diagonalColor ].
	(self isDependency: tuple) ifFalse: [ ^self defaultColor ].

	(self isCycle: tuple) ifTrue: [ ^ self sccColor ].
	^ self dependencyColor
]

{ #category : 'initialization' }
MiDSMModel >> computeMatrixWithX: entitiesX withY: entitiesY [

	self selectedEntities: (entitiesX union: entitiesY).
	
	dependencies computeDependenciesWithX: entitiesX withY: entitiesY .

	graph buildGraph 

]

{ #category : 'settings management' }
MiDSMModel >> currentConfiguration [

	^ MiDSMSettingsConfiguration new
		  shouldShowSelfDependencies: shouldShowSelfDependencies;
		  yourself
]

{ #category : 'settings' }
MiDSMModel >> defaultColor [

	^ nodeColors at: #defaultCell
]

{ #category : 'settings management' }
MiDSMModel >> defaultConfiguration [

	^ self class defaultConfiguration
]

{ #category : 'accessing' }
MiDSMModel >> dependencies [

	^ dependencies
]

{ #category : 'settings' }
MiDSMModel >> dependencyColor [

	^ nodeColors at: #dependency
]

{ #category : 'settings' }
MiDSMModel >> diagonalColor [

	^nodeColors at: #diagonalCell
]

{ #category : 'api' }
MiDSMModel >> displayValueForNode: aNode [
	^aNode model name
]

{ #category : 'api' }
MiDSMModel >> displayValueForTuple: tuple [
	^(self displayValueForNode: tuple key), ' -> ' , (self displayValueForNode: tuple value)
]

{ #category : 'accessing' }
MiDSMModel >> entities [

	^dependencies entities
]

{ #category : 'actions' }
MiDSMModel >> followEntity: aCollection [
	"initializing the DSM from a collection of entities received on the data bus (see also #withX:withY:)
	 In this case, this is a square matrix of dependency"

	self computeMatrixWithX: aCollection withY: aCollection.

	orderedNodesX := self orderNodes: aCollection.
	orderedNodesY := orderedNodesX.

	browser buildDSM
]

{ #category : 'api' }
MiDSMModel >> getTupleDependencyWeight: tuple [
	"Generic algorithm is to take all dependencies of the `tuple key` (column of the DSM) and count 
	those that can be scoped up to the `tuple value` (row of the DSM)
	- If `tuple key` = `tuple value`, it is a diagonal cell.
	- If shouldShowSelfDependencies is false, return 0 so that no value is displayed"

	(tuple key model = tuple value model and: [
		 shouldShowSelfDependencies not ]) ifTrue: [ ^ 0 ].

	^ dependencies weightFrom: tuple key model to: tuple value model
]

{ #category : 'accessing' }
MiDSMModel >> graph [

	^graph
]

{ #category : 'testing' }
MiDSMModel >> hasSettings [

	^ true
]

{ #category : 'initialization' }
MiDSMModel >> initialize [ 
	super initialize.

	self initializeColors.
	self initializeSettings .
	
	dependencies := MiDSMDependencyManager on: self.
	graph := MiDSMDependencyGraph new dependencies: self dependencies.

	selectedEntities := #().
	orderedNodesY := orderedNodesX := #().

]

{ #category : 'initialization' }
MiDSMModel >> initializeColors [
	nodeColors := Dictionary new: 5.

	nodeColors at: #diagonalCell put: Color veryLightGray.

	nodeColors at: #scc put: Color lightRed.
	nodeColors at: #showSCC put: Color red.

	"very light gray for cell not in diagonal and not in dependency"
	nodeColors at: #defaultCell put: (Color r: 0.9 g: 0.9 b: 0.9).

	"a 'nice' blue for cells with dependency"
	nodeColors at: #dependency put: (Color colorFrom: '#659ef6').
]

{ #category : 'initialization' }
MiDSMModel >> initializeSettings [

	shouldShowSelfDependencies := true
]

{ #category : 'testing' }
MiDSMModel >> isCycle: tuple [

	^graph inCycle: tuple key with: tuple value
]

{ #category : 'testing' }
MiDSMModel >> isDependency: tuple [

	^(dependencies from: tuple key model to: tuple value model) isNotEmpty
]

{ #category : 'testing' }
MiDSMModel >> isDiagonal: tuple [

	^tuple key = tuple value

]

{ #category : 'api' }
MiDSMModel >> listTupleDependencies: tuple [

	(tuple key model = tuple value model and: [
		 shouldShowSelfDependencies not ]) ifTrue: [ ^ #(  ) ].

	^ dependencies from: tuple key model to: tuple value model
]

{ #category : 'accessing' }
MiDSMModel >> miSelectedItem [

	^selectedEntities
]

{ #category : 'actions' }
MiDSMModel >> openDetailedDSMOn: aTuple [
	"creating a new (detailed) DSM from	aTuple = fromEntity -> toEntity"

	^ (MiDSMBrowser
		   openWithX: aTuple key model containedEntities
		   withY: aTuple value model containedEntities)
		  withWindowDo: [ :window |
				  window title:
						  'DSM ' , aTuple key model name , ' -> '
						  , aTuple value model name ];
		  yourself
]

{ #category : 'actions' }
MiDSMModel >> orderNodes: entities [
	"order nodes according to number of dependencies
	 Order is:
	 - put first entities with less dependents (ignoring weights)
	 - put first entities with weaker dependents based on weights"

	| dependents weights |
	entities ifEmpty: [ ^#() ].

	dependents := Dictionary new: selectedEntities size.
	weights := Dictionary new: selectedEntities size.

	selectedEntities do: [ :entity |
		dependents at: entity put: 0.
		weights at: entity put: 0.
	].

	dependencies allDependencyPairsDo: [ :fromEntity :toEntity :pairDependencies |
		dependents at: toEntity put: (dependents at: toEntity) + 1.
		weights at: toEntity put: (weights at: toEntity) + pairDependencies size.
	].
	
	^(entities sorted:
		([:entityA | dependents at: entityA] ascending, 
		[:entityA | weights at: entityA] ascending,
		[:entityA | entityA name asLowercase ] ascending)
	) 	
		collect: [ :entity | graph findNode: entity ]
]

{ #category : 'accessing' }
MiDSMModel >> orderedNodesX [
	^orderedNodesX
]

{ #category : 'accessing' }
MiDSMModel >> orderedNodesY [
	^orderedNodesY
]

{ #category : 'settings' }
MiDSMModel >> sccColor [

	^ nodeColors at: #scc
]

{ #category : 'api' }
MiDSMModel >> sccTuplesForTuple: tuple [
	"gets the SCC owning tuple, then collects all tuples in this SCC
	 where depending entity depends on depended entity (!)"
	| scc graphNode |
	graphNode := tuple key.
	scc := { graphNode } , graphNode cycleNodes.
	^(scc size = 1)
		ifTrue: [ #() ]
		ifFalse: [
			scc flatCollect: [ :dependingNode |
				dependingNode adjacentNodes
					collect: [ :dependedNode | dependingNode -> dependedNode ]
					thenSelect: [ :sccTuple | self isCycle: sccTuple ]
			]
		]
]

{ #category : 'accessing' }
MiDSMModel >> selectedEntities: anObject [

	selectedEntities := anObject.

	browser updateToolbar
]

{ #category : 'settings management' }
MiDSMModel >> settingsPresenterExtent [

	^ 350 @ 200
]

{ #category : 'settings' }
MiDSMModel >> showSCCColor [

	^ nodeColors at: #showSCC
]

{ #category : 'api' }
MiDSMModel >> showSCCColorForTuple: tuple [
	"same as #colorForTuple: but highlighting SCCs"

	(self isDiagonal: tuple) ifTrue: [ ^self diagonalColor ].
	(self isDependency: tuple) ifFalse: [ ^self defaultColor ].

	(self isCycle: tuple) ifTrue: [ ^ self showSCCColor ].
	^ self dependencyColor
]

{ #category : 'settings management' }
MiDSMModel >> updateFromConfiguration: aConfiguration [

	shouldShowSelfDependencies := aConfiguration shouldShowSelfDependencies.

	browser buildDSM
]

{ #category : 'actions' }
MiDSMModel >> userActionOn: aTuple [
	| depending depended weight|
	depending := aTuple key model.
	depended := aTuple value model.
	weight := self getTupleDependencyWeight: aTuple.
	
	self selectedEntities: { depending . depended }.

	"We open a detailed DSM for a typle only if the tuple key and value are still at the class or package level and the weight is not zero. "
	self flag: 'might want to review this which is OO dependent'.
	((depending usesFamixTrait: FamixTAttribute ) 
		or: [ (depending usesFamixTrait: FamixTMethod ) 
			or: [ (depended usesFamixTrait: FamixTAttribute)
				or: [ (depended usesFamixTrait: FamixTMethod) or: [ weight = 0 ] ] ] ])	
		ifFalse: [self openDetailedDSMOn: aTuple] 
		ifTrue: [  ]

]

{ #category : 'actions' }
MiDSMModel >> withX: entitiesX withY: entitiesY [
	"initializing the DSM for two list of entities (see also #followEntity:)
	 In this case, this is probably not a suqare matrix of dependency"

	"| allEntities |
	allEntities := entitiesX union: entitiesY."

	"self computeMatrix: allEntities."

	self computeMatrixWithX: entitiesX withY: entitiesY.

	orderedNodesX := self orderNodes: entitiesX.
	orderedNodesY := self orderNodes: entitiesY.

	browser buildDSM
]
