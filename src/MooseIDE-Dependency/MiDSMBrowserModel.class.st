"
A model for the MiDSMBrowser, contains the entities to display, computes the dependencies and the colors to show the cells of the DSM matrix
"
Class {
	#name : #MiDSMBrowserModel,
	#superclass : #MiAbstractModel,
	#instVars : [
		'graph',
		'nodeColors',
		'orderedNodesX',
		'orderedNodesY',
		'selectedEntities',
		'settings',
		'dependencies'
	],
	#category : #'MooseIDE-Dependency-DSM'
}

{ #category : #buildGraph }
MiDSMBrowserModel >> buildGraph: aCollection [

	self newGraph.
	self buildGraphNodes: aCollection.

	dependencies initializeDependencies.

	self buildGraphEdges.
	self computeSCCs
]

{ #category : #buildGraph }
MiDSMBrowserModel >> buildGraphEdges [
	"We choose to say that there is a relation from line to column if line depends on column"
	| entities |
	entities := self entities.
	
	graph
			edges: entities
			from: #yourself
			toAll: [ :sourceEntity | 
				entities select: [ :targetEntity | 
					(dependencies from: sourceEntity to: targetEntity) isNotEmpty 
				]
			]
]

{ #category : #buildGraph }
MiDSMBrowserModel >> buildGraphNodes: aCollection [

	graph nodes: (aCollection select: [ :e | 
			 e usesFamixTrait: TEntityMetaLevelDependency ]).

]

{ #category : #testing }
MiDSMBrowserModel >> canFollowEntity: anObject [

	^ anObject isCollection and: [ 
		  anObject allSatisfy: [ :a | 
			  a usesFamixTrait: TEntityMetaLevelDependency ] ].
]

{ #category : #api }
MiDSMBrowserModel >> colorForTuple: tuple [

	(self isDiagonal: tuple) ifTrue: [ ^self diagonalColor ].
	(self isDependency: tuple) ifFalse: [ ^self defaultColor ].

	(self isCycle: tuple) ifTrue: [ ^ self sccColor ].
	^ self dependencyColor
]

{ #category : #buildGraph }
MiDSMBrowserModel >> computeSCCs [
	"run tarjan"
	graph run
]

{ #category : #settings }
MiDSMBrowserModel >> defaultColor [

	^ nodeColors at: #defaultCell
]

{ #category : #accessing }
MiDSMBrowserModel >> dependencies [

	^ dependencies
]

{ #category : #settings }
MiDSMBrowserModel >> dependencyColor [

	^ nodeColors at: #dependency
]

{ #category : #settings }
MiDSMBrowserModel >> diagonalColor [

	^nodeColors at: #diagonalCell
]

{ #category : #api }
MiDSMBrowserModel >> displayValueForNode: aNode [
	^aNode model name
]

{ #category : #api }
MiDSMBrowserModel >> displayValueForTuple: tuple [
	^(self displayValueForNode: tuple key), ' -> ' , (self displayValueForNode: tuple value)
]

{ #category : #accessing }
MiDSMBrowserModel >> entities [

	^ graph nodes collect: #model
]

{ #category : #actions }
MiDSMBrowserModel >> entityChildrenForDSM: anEntity [
	"children of an entity except concretization of generic entities which are considered more
	 like associations"

	^anEntity children reject: [ :child |
		(child usesFamixTrait: FamixTParametricEntity) and:
		[ child genericization isNotNil ]
	]
	
]

{ #category : #actions }
MiDSMBrowserModel >> followEntity: aCollection [

	self selectedEntities: aCollection.

	self buildGraph: aCollection.

	orderedNodesX := self orderNodes: graph nodes.
	orderedNodesY := orderedNodesX.

	browser buildDSM
]

{ #category : #api }
MiDSMBrowserModel >> getTupleDependencyWeight: tuple [
	"generic algorithm is to take all dependencies of the `tuple key` (column of the DSM) and count
	 those that can be scoped up to the `tuple value` (row of the DSM)
	
	 if `tuple key` = `tuple value`, it is a diagonal cell.
	 If setting showSelfDependencies is false, return 0 so that no value is displayed"

	((tuple key model = tuple value model)
	and: [ self showSelfDependencies not ])
		ifTrue: [ ^0 ].

	^dependencies weightFrom: tuple key model to: tuple value model
]

{ #category : #actions }
MiDSMBrowserModel >> increment: dictionary key: key value: increment [

	| oldValue |
	oldValue := dictionary at: key ifAbsent: [ ^self ].

	dictionary at: key put: oldValue + increment
]

{ #category : #initialization }
MiDSMBrowserModel >> initialize [ 
	super initialize.

	self initializeColors.
	self newGraph.
	selectedEntities := #().
	dependencies := MiDSMDependencyManager on: self.

	self initializeSettings 
]

{ #category : #initialization }
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

{ #category : #initialization }
MiDSMBrowserModel >> initializeSettings [ 

	settings := super initializeSettings.
	settings	addItem: (MiCheckboxSettingItem new
		setValue: true ;
		label: 'Show self dependency?' ;
		help: 'In a square matrix, show the number of dependencies of an entity with itself on the diagonal?' ;
		yourself)
		named: #selfDependenciesSetting.

]

{ #category : #testing }
MiDSMBrowserModel >> isCycle: tuple [

	^tuple key cycleNodes
		includes: tuple value
]

{ #category : #testing }
MiDSMBrowserModel >> isDependency: tuple [

	^tuple key adjacentNodes
		includes: tuple value
]

{ #category : #testing }
MiDSMBrowserModel >> isDiagonal: tuple [

	^tuple key = tuple value

]

{ #category : #accessing }
MiDSMBrowserModel >> miSelectedItem [

	^selectedEntities
]

{ #category : #buildGraph }
MiDSMBrowserModel >> newGraph [
	graph := AITarjan new.

	orderedNodesX := #().
	orderedNodesY := #()
]

{ #category : #actions }
MiDSMBrowserModel >> openDetailedDSMOn: aTuple [

	^(MiDSMBrowser
		openWithX: (self entityChildrenForDSM: aTuple key model)
		withY: (self entityChildrenForDSM: aTuple value model))

		withWindowDo: [ :window |
			window title: ('DSM ' , aTuple key model name , ' -> ' , aTuple value model name) ] ;
		yourself
]

{ #category : #actions }
MiDSMBrowserModel >> orderNodes: nodeCollection [

	"order nodes according to number of dependencies
	 Order is:
	 - put first entities with less dependents (ignoring weights)
	 - put first entities with weaker dependents based on weights"

	| dependents weights |
	dependents := Dictionary new: nodeCollection size.
	weights := Dictionary new: nodeCollection size.

	nodeCollection do: [ :node |
		dependents at: node model put: 0.
		weights at: node model put: 0.
	].

	dependencies allDependencyPairsDo: [ :fromEntity :toEntity :pairDependencies |
		self increment: dependents key: toEntity value: 1.
		self increment: weights key: toEntity value: pairDependencies size.
	].

	^nodeCollection sorted: [ :nodeA :nodeB || depsA depsB |
		depsA := dependents at: nodeA model.
		depsB := dependents at: nodeB model.

		(depsA < depsB)
		or: [ (depsA = depsB) and: [ (weights at: nodeA model) < (weights at: nodeB model) ] ]
	]
]

{ #category : #accessing }
MiDSMBrowserModel >> orderedNodesX [
	^orderedNodesX
]

{ #category : #accessing }
MiDSMBrowserModel >> orderedNodesY [
	^orderedNodesY
]

{ #category : #settings }
MiDSMBrowserModel >> sccColor [

	^ nodeColors at: #scc
]

{ #category : #api }
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

{ #category : #accessing }
MiDSMBrowserModel >> selectedEntities: anObject [

	selectedEntities := anObject.

	browser updateToolbar
]

{ #category : #settings }
MiDSMBrowserModel >> settings [
	"If browser hasSettings, then implement this method to get them"

	^settings 
]

{ #category : #settings }
MiDSMBrowserModel >> settingsChanged: aBoolean [

	aBoolean ifTrue: [ browser buildDSM ]
]

{ #category : #settings }
MiDSMBrowserModel >> showSCCColor [

	^ nodeColors at: #showSCC
]

{ #category : #api }
MiDSMBrowserModel >> showSCCColorForTuple: tuple [
	"same as #colorForTuple: but highlighting SCCs"

	(self isDiagonal: tuple) ifTrue: [ ^self diagonalColor ].
	(self isDependency: tuple) ifFalse: [ ^self defaultColor ].

	(self isCycle: tuple) ifTrue: [ ^ self showSCCColor ].
	^ self dependencyColor
]

{ #category : #settings }
MiDSMBrowserModel >> showSelfDependencies [

	^ settings getItemValue: #selfDependenciesSetting
]

{ #category : #actions }
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

{ #category : #actions }
MiDSMBrowserModel >> withX: entitiesX withY: entitiesY [

	| allEntities |
	allEntities := entitiesX union: entitiesY.

	self selectedEntities: allEntities.
	self buildGraph: allEntities.

	orderedNodesX := self orderNodes: (entitiesX collect: [ :each | graph findNode: each]).
	orderedNodesY := self orderNodes: (entitiesY collect: [ :each | graph findNode: each]).

	browser buildDSM
]
