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
		'nodeColors'
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

{ #category : #utilities }
MiDSMBrowserModel >> buildGraphEdges [
	"We choose to say that there is a relation from line to column if line depends on column"
	| entities |
	entities := self entities.
	entities do: [ :entity |
		graph
			edges: { entity }
			from: #yourself
			toAll: [ :sourceEntity |
				"removed call to #withoutSelfLoop because it is too expansive to compute"
				(sourceEntity queryAllOutgoing atScope: sourceEntity class) intersection: entities
			]
	]
]

{ #category : #utilities }
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

{ #category : #utilities }
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

{ #category : #initialization }
MiDSMBrowserModel >> newGraph [
	graph := AITarjan new.
]

{ #category : #api }
MiDSMBrowserModel >> nodesOrdered [

	^graph nodes sorted: [ :nodeA :nodeB | 
		nodeA adjacentNodes size < nodeB adjacentNodes size or: [ 
			nodeA adjacentNodes size = nodeB adjacentNodes size and: [ 
				nodeA model name < nodeB model name ] ] ]
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
