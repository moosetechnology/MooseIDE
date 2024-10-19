"
A model for the MiDSMBrowser, contains the entities to display, computes the dependencies and the colors to show the cells of the DSM matrix
"
Class {
	#name : #MiDependencyStructuralMatrixBrowserModel,
	#superclass : #MiAbstractModel,
	#instVars : [
		'graph',
		'nodeDictionary',
		'nodeColors',
		'orderedNodes'
	],
	#category : #'MooseIDE-Dependency-DSM'
}

{ #category : #buildGraph }
MiDependencyStructuralMatrixBrowserModel >> buildGraphEdges [
	"We choose to say that there is a relation from line to column if line depends on column"
	| entities |
	entities := self entities.
	entities do: [ :entity |
		graph
			edges: { entity }
			from: #yourself
			toAll: [ :sourceEntity |
				"replaced call to #withoutSelfLoop (too expansive to compute) by intersection without sourcedEntity
				 Note: intersection otherwise needed to restrict result to only entities in the model"
				(sourceEntity queryAllOutgoing atScope: sourceEntity class) intersection: (entities reject: [:e | e = sourceEntity])
			]
	]
]

{ #category : #buildGraph }
MiDependencyStructuralMatrixBrowserModel >> buildGraphNodes: aCollection [

	graph nodes: (aCollection asMooseGroup select: [ :e | 
			 e usesFamixTrait: TEntityMetaLevelDependency ]).
	nodeDictionary := Dictionary new: aCollection size.
	graph nodes do: [ :node | nodeDictionary at: node model put: node ]
]

{ #category : #testing }
MiDependencyStructuralMatrixBrowserModel >> canFollowEntity: anObject [

	^ anObject isCollection and: [ 
		  anObject allSatisfy: [ :a | 
			  a usesFamixTrait: TEntityMetaLevelDependency ] ].
]

{ #category : #api }
MiDependencyStructuralMatrixBrowserModel >> colorForTuple: tuple [

	(self isDiagonal: tuple) ifTrue: [ ^self diagonalColor ].
	(self isDependency: tuple) ifFalse: [ ^self defaultColor ].

	(self isCycle: tuple) ifTrue: [ ^ self sccColor ].
	^ self dependencyColor
]

{ #category : #buildGraph }
MiDependencyStructuralMatrixBrowserModel >> computeSCCs [
	"run tarjan"
	graph run
]

{ #category : #settings }
MiDependencyStructuralMatrixBrowserModel >> defaultColor [

	^ nodeColors at: #defaultCell
]

{ #category : #settings }
MiDependencyStructuralMatrixBrowserModel >> dependencyColor [
	"a 'nice' blue for cells with dependency"
	^ nodeColors at: #dependency
]

{ #category : #settings }
MiDependencyStructuralMatrixBrowserModel >> diagonalColor [

	^nodeColors at: #diagonalCell
]

{ #category : #api }
MiDependencyStructuralMatrixBrowserModel >> displayValueForNode: aNode [
	^aNode model name
]

{ #category : #api }
MiDependencyStructuralMatrixBrowserModel >> displayValueForTuple: tuple [
	^(self displayValueForNode: tuple key), ' -> ' , (self displayValueForNode: tuple value)
]

{ #category : #accessing }
MiDependencyStructuralMatrixBrowserModel >> entities [

	^ graph nodes collect: #model
]

{ #category : #testing }
MiDependencyStructuralMatrixBrowserModel >> entity: aCandidate belongsTo: anEntity [
	"test whether aDependentEntity can be scoped up to anEntity"

	^(aCandidate atScope: anEntity class) includes: anEntity
]

{ #category : #actions }
MiDependencyStructuralMatrixBrowserModel >> followEntity: aCollection [

	self newGraph.
	self buildGraphNodes: aCollection.
	self buildGraphEdges.
	self orderNodes.
	self computeSCCs.
	browser buildDSM
]

{ #category : #api }
MiDependencyStructuralMatrixBrowserModel >> getTupleDependencyWeight: tuple [
	"generic algorithm is to take all dependencies of the `tuple key` (row of the DSM) and count
	 those that can be scoped up to the `tuple value` (column of the DSM)"

	^tuple key model queryAllOutgoingForDSM count: [ :dependency || opposites |
		dependency isAssociation ifTrue: [
			"Association so need to get the target because DSM is done between entities"
			opposites := dependency target.
			opposites isCollection
			ifTrue: [ opposites anySatisfy: [ :each |
					self entity: each belongsTo: tuple value model ]
			]
			ifFalse: [
				self flag: 'can be nil because of a bug in the model with generic types'.
				opposites 
					ifNotNil: [ self entity: opposites belongsTo: tuple value model ] 
					ifNil: [false]
				]
			]
		ifFalse: [ 
			"case of declaredType"
			dependency isStub
				ifTrue: [ false ]
				ifFalse: [ self entity: dependency belongsTo: tuple value model ]
			 ]
	]
]

{ #category : #initialization }
MiDependencyStructuralMatrixBrowserModel >> initialize [ 
	super initialize.
	self initializeColors.
	self newGraph.
]

{ #category : #initialization }
MiDependencyStructuralMatrixBrowserModel >> initializeColors [
	nodeColors := Dictionary new: 5.

	nodeColors at: #diagonalCell put: Color veryLightGray.
	nodeColors at: #scc put: Color lightRed.
	nodeColors at: #showSCC put: Color red.
	"extremely light gray for cell not in diagonal and not in dependency"
	nodeColors at: #defaultCell put: (Color r: 0.9 g: 0.9 b: 0.9).
	"a 'nice' blue for cells with dependency"
	nodeColors at: #dependency put: (Color colorFrom: '#4d79ff').

]

{ #category : #testing }
MiDependencyStructuralMatrixBrowserModel >> isCycle: tuple [

	^tuple key cycleNodes includes: tuple value
]

{ #category : #testing }
MiDependencyStructuralMatrixBrowserModel >> isDependency: tuple [

	^tuple key adjacentNodes includes: tuple value
]

{ #category : #testing }
MiDependencyStructuralMatrixBrowserModel >> isDiagonal: tuple [
	^tuple key = tuple value

]

{ #category : #accessing }
MiDependencyStructuralMatrixBrowserModel >> miSelectedItem [

	^ self entities
]

{ #category : #buildGraph }
MiDependencyStructuralMatrixBrowserModel >> newGraph [
	graph := AITarjan new.
	orderedNodes := #()
]

{ #category : #accessing }
MiDependencyStructuralMatrixBrowserModel >> nodesOrdered [
	^orderedNodes
]

{ #category : #buildGraph }
MiDependencyStructuralMatrixBrowserModel >> orderNodes [
	"Store ordered nodes in #orderedNodes.
	 Order is:
	 - number of combined in and out dependencies
	 - if equal, number of out dependencies
	 - if also equal, then name"
	| incomingEdges |

	incomingEdges := Dictionary new: graph nodes size.
	graph nodes do: [ :node | incomingEdges at: node put: Set new ].
	graph nodes do: [ :node |
		node adjacentNodes do: [ :adjacent |
			(incomingEdges at: adjacent) add: node
		].
	].
	orderedNodes := graph nodes sorted: [ :nodeA :nodeB || outA inA outB inB|
		outA := nodeA adjacentNodes size.
		inA := (incomingEdges at: nodeA) size.
		outB := nodeB adjacentNodes size.
		inB := (incomingEdges at: nodeB) size.
		
		(inA + outA) < (inB + outB)
		or: [ (inA + outA) = (inB + outB)
			ifTrue: [ outA < outB
				or: [ outA = outB and: [nodeA model name < nodeB model name] ] ]
			ifFalse: [ false ] ] ].

]

{ #category : #settings }
MiDependencyStructuralMatrixBrowserModel >> sccColor [

	^ nodeColors at: #scc
]

{ #category : #api }
MiDependencyStructuralMatrixBrowserModel >> sccTuplesForTuple: tuple [
	"gets the SCC owning tuple, then collects all tuples in this SCC
	 where row entity depends on column entity"
	| scc graphNode |
	graphNode := tuple key.
	scc := { graphNode } , graphNode cycleNodes.
	^(scc size = 1)
		ifTrue: [ #() ]
		ifFalse: [
			scc flatCollect: [ :rowNode |
				rowNode adjacentNodes
					collect: [ :columnNode | rowNode -> columnNode ]
					thenSelect: [ :sccTuple | self isCycle: sccTuple ]
			]
		]
]

{ #category : #settings }
MiDependencyStructuralMatrixBrowserModel >> showSCCColor [

	^ nodeColors at: #showSCC
]

{ #category : #api }
MiDependencyStructuralMatrixBrowserModel >> showSCCColorForTuple: tuple [
	"same as #colorForX:y: but highlighting SCCs"
	(self isDiagonal: tuple) ifTrue: [ ^self diagonalColor ].
	(self isDependency: tuple) ifFalse: [ ^self defaultColor ].

	(self isCycle: tuple) ifTrue: [ ^ self showSCCColor ].
	^ self dependencyColor
]
