"
A model for the MiDSMBrowser, contains the entities to display, computes the dependencies and the colors to show the cells of the DSM matrix
"
Class {
	#name : #MiDSMBrowserModel,
	#superclass : #Object,
	#instVars : [
		'browser',
		'graph',
		'nodeDictionary',
		'nodeColors',
		'orderedNodes'
	],
	#category : #'MooseIDE-Dependency-DSM'
}

{ #category : #accessing }
MiDSMBrowserModel >> browser [

	^ browser
]

{ #category : #accessing }
MiDSMBrowserModel >> browser: anObject [

	browser := anObject
]

{ #category : #buildGraph }
MiDSMBrowserModel >> buildGraphEdges [
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
MiDSMBrowserModel >> buildGraphNodes: aCollection [

	graph nodes: (aCollection asMooseGroup select: [ :e | 
			 e usesFamixTrait: TEntityMetaLevelDependency ]).
	nodeDictionary := Dictionary new: aCollection size.
	graph nodes do: [ :node | nodeDictionary at: node model put: node ]
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

{ #category : #settings }
MiDSMBrowserModel >> dependencyColor [
	"a 'nice' blue for cells with dependency"
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
	^graph nodes collect: #model
]

{ #category : #actions }
MiDSMBrowserModel >> followEntity: aCollection [

	self newGraph.
	self buildGraphNodes: aCollection.
	self buildGraphEdges.
	self orderNodes.
	self computeSCCs.
	browser buildDSM
]

{ #category : #actions }
MiDSMBrowserModel >> highlightEntity: anEntity [

	"browser highlightEntities: anEntity asCollection"
]

{ #category : #initialization }
MiDSMBrowserModel >> initialize [ 
	super initialize.
	self initializeColors.
	self newGraph.
]

{ #category : #initialization }
MiDSMBrowserModel >> initializeColors [
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
MiDSMBrowserModel >> isCycle: tuple [

	^tuple key cycleNodes includes: tuple value
]

{ #category : #testing }
MiDSMBrowserModel >> isDependency: tuple [

	^tuple key adjacentNodes includes: tuple value
]

{ #category : #testing }
MiDSMBrowserModel >> isDiagonal: tuple [
	^tuple key = tuple value

]

{ #category : #buildGraph }
MiDSMBrowserModel >> newGraph [
	graph := AITarjan new.
	orderedNodes := #()
]

{ #category : #accessing }
MiDSMBrowserModel >> nodesOrdered [
	^orderedNodes
]

{ #category : #buildGraph }
MiDSMBrowserModel >> orderNodes [
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
MiDSMBrowserModel >> sccColor [

	^ nodeColors at: #scc
]

{ #category : #api }
MiDSMBrowserModel >> sccTuplesForTuple: tuple [
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

{ #category : #accessing }
MiDSMBrowserModel >> selectedEntities [
	^#()
]

{ #category : #settings }
MiDSMBrowserModel >> showSCCColor [

	^ nodeColors at: #showSCC
]

{ #category : #api }
MiDSMBrowserModel >> showSCCColorForTuple: tuple [
	"same as #colorForX:y: but highlighting SCCs"
	(self isDiagonal: tuple) ifTrue: [ ^self diagonalColor ].
	(self isDependency: tuple) ifFalse: [ ^self defaultColor ].

	(self isCycle: tuple) ifTrue: [ ^ self showSCCColor ].
	^ self dependencyColor
]
