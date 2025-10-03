"
A model for the MiDSMBrowser, contains the entities to display, computes the dependencies and the colors to show the cells of the DSM matrix
"
Class {
	#name : 'MiDSMBrowserModel',
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
	#category : 'MooseIDE-Dependency-DSM',
	#package : 'MooseIDE-Dependency',
	#tag : 'DSM'
}

{ #category : 'settings management' }
MiDSMBrowserModel class >> defaultConfiguration [

	^ MiDSMSettingsConfiguration new
		  shouldShowSelfDependencies: self defaultShouldShowSelfDependencies;
		  yourself
]

{ #category : 'default' }
MiDSMBrowserModel class >> defaultShouldShowSelfDependencies [

	^ true
]

{ #category : 'testing' }
MiDSMBrowserModel >> canFollowEntity: anObject [

	^ anObject isCollection and: [ 
		  anObject allSatisfy: [ :a | 
			  a usesFamixTrait: TEntityMetaLevelDependency ] ].
]

{ #category : 'api' }
MiDSMBrowserModel >> colorForTuple: tuple [

	(self isDiagonal: tuple) ifTrue: [ ^self diagonalColor ].
	(self isDependency: tuple) ifFalse: [ ^self defaultColor ].

	(self isCycle: tuple) ifTrue: [ ^ self sccColor ].
	^ self dependencyColor
]

{ #category : 'initialization' }
MiDSMBrowserModel >> computeMatrixWithX: entitiesX withY: entitiesY [

	self selectedEntities: (entitiesX union: entitiesY).
	
	dependencies computeDependenciesWithX: entitiesX withY: entitiesY .

	graph buildGraph 

]

{ #category : 'settings management' }
MiDSMBrowserModel >> currentConfiguration [

	^ MiDSMSettingsConfiguration new
		  shouldShowSelfDependencies: shouldShowSelfDependencies;
		  yourself
]

{ #category : 'settings' }
MiDSMBrowserModel >> defaultColor [

	^ nodeColors at: #defaultCell
]

{ #category : 'settings management' }
MiDSMBrowserModel >> defaultConfiguration [

	^ self class defaultConfiguration
]

{ #category : 'accessing' }
MiDSMBrowserModel >> dependencies [

	^ dependencies
]

{ #category : 'settings' }
MiDSMBrowserModel >> dependencyColor [

	^ nodeColors at: #dependency
]

{ #category : 'settings' }
MiDSMBrowserModel >> diagonalColor [

	^nodeColors at: #diagonalCell
]

{ #category : 'api' }
MiDSMBrowserModel >> displayValueForNode: aNode [
	^aNode model name
]

{ #category : 'api' }
MiDSMBrowserModel >> displayValueForTuple: tuple [
	^(self displayValueForNode: tuple key), ' -> ' , (self displayValueForNode: tuple value)
]

{ #category : 'accessing' }
MiDSMBrowserModel >> entities [

	^dependencies entities
]

{ #category : 'actions' }
MiDSMBrowserModel >> followEntity: aCollection [
	"initializing the DSM from a collection of entities received on the data bus (see also #withX:withY:)
	 In this case, this is a square matrix of dependency"

	self computeMatrixWithX: aCollection withY: aCollection.

	orderedNodesX := self orderNodes: aCollection.
	orderedNodesY := orderedNodesX.

	browser buildDSM
]

{ #category : 'api' }
MiDSMBrowserModel >> getTupleDependencyWeight: tuple [
	"Generic algorithm is to take all dependencies of the `tuple key` (column of the DSM) and count 
	those that can be scoped up to the `tuple value` (row of the DSM)
	- If `tuple key` = `tuple value`, it is a diagonal cell.
	- If shouldShowSelfDependencies is false, return 0 so that no value is displayed"

	(tuple key model = tuple value model and: [
		 shouldShowSelfDependencies not ]) ifTrue: [ ^ 0 ].

	^ dependencies weightFrom: tuple key model to: tuple value model
]

{ #category : 'accessing' }
MiDSMBrowserModel >> graph [

	^graph
]

{ #category : 'testing' }
MiDSMBrowserModel >> hasSettings [

	^ true
]

{ #category : 'initialization' }
MiDSMBrowserModel >> initialize [ 
	super initialize.

	self initializeColors.
	self initializeSettings .
	
	dependencies := MiDSMDependencyManager on: self.
	graph := MiDSMDependencyGraph new dependencies: self dependencies.

	selectedEntities := #().
	orderedNodesY := orderedNodesX := #().

]

{ #category : 'initialization' }
MiDSMBrowserModel >> initializeColors [
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
MiDSMBrowserModel >> initializeSettings [

	shouldShowSelfDependencies := true
]

{ #category : 'testing' }
MiDSMBrowserModel >> isCycle: tuple [

	^graph inCycle: tuple key with: tuple value
]

{ #category : 'testing' }
MiDSMBrowserModel >> isDependency: tuple [

	^(dependencies from: tuple key model to: tuple value model) isNotEmpty
]

{ #category : 'testing' }
MiDSMBrowserModel >> isDiagonal: tuple [

	^tuple key = tuple value

]

{ #category : 'api' }
MiDSMBrowserModel >> listTupleDependencies: tuple [

	(tuple key model = tuple value model and: [
		 shouldShowSelfDependencies not ]) ifTrue: [ ^ #(  ) ].

	^ dependencies from: tuple key model to: tuple value model
]

{ #category : 'accessing' }
MiDSMBrowserModel >> miSelectedItem [

	^selectedEntities
]

{ #category : 'actions' }
MiDSMBrowserModel >> openDetailedDSMOn: aTuple [
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
MiDSMBrowserModel >> orderNodes: entities [
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
MiDSMBrowserModel >> orderedNodesX [
	^orderedNodesX
]

{ #category : 'accessing' }
MiDSMBrowserModel >> orderedNodesY [
	^orderedNodesY
]

{ #category : 'settings' }
MiDSMBrowserModel >> sccColor [

	^ nodeColors at: #scc
]

{ #category : 'api' }
MiDSMBrowserModel >> sccTuplesForTuple: tuple [
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
MiDSMBrowserModel >> selectedEntities: anObject [

	selectedEntities := anObject.

	browser updateToolbar
]

{ #category : 'settings management' }
MiDSMBrowserModel >> settingsPresenterExtent [

	^ 350 @ 200
]

{ #category : 'settings' }
MiDSMBrowserModel >> showSCCColor [

	^ nodeColors at: #showSCC
]

{ #category : 'api' }
MiDSMBrowserModel >> showSCCColorForTuple: tuple [
	"same as #colorForTuple: but highlighting SCCs"

	(self isDiagonal: tuple) ifTrue: [ ^self diagonalColor ].
	(self isDependency: tuple) ifFalse: [ ^self defaultColor ].

	(self isCycle: tuple) ifTrue: [ ^ self showSCCColor ].
	^ self dependencyColor
]

{ #category : 'settings management' }
MiDSMBrowserModel >> updateFromConfiguration: aConfiguration [

	shouldShowSelfDependencies := aConfiguration shouldShowSelfDependencies.

	browser buildDSM
]

{ #category : 'actions' }
MiDSMBrowserModel >> userActionOn: aTuple [
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
MiDSMBrowserModel >> withX: entitiesX withY: entitiesY [
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
