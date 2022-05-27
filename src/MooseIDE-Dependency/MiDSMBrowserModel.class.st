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
MiDSMBrowserModel >> associationsSCCFor: anEntity [

	| graphNode scc |
	graphNode := self findNode: anEntity.
	scc := { graphNode } , graphNode cycleNodes.
	^ (scc flatCollect: [ :src | 
		   scc collect: [ :tgt | src model -> tgt model ] ]) select: [ 
		  :assoc | self isDependantX: assoc key onY: assoc value ]
]

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
	"RSDSM conventions: X entities are at the top of the matricx, Y entities at the left
	We choose to say that there is a relation from X to Y if Y depends on X"
	| entities |
	entities := self entities.
	entities do: [ :entity |
		graph
			edges: { entity }
			from: #yourself
			toAll: [ :sourceEntity |
				(sourceEntity queryAllIncoming atScope: sourceEntity class) intersection: entities
			]
	]
]

{ #category : #actions }
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

{ #category : #accessing }
MiDSMBrowserModel >> colorForX: xEntity y: yEntity [

	(self isDiagonalX: xEntity y: yEntity) ifTrue: [ 
		^ self diagonalCellColor ].
	(self isDependantX: xEntity onY: yEntity) ifFalse: [ 
		^ self defaultCellColor ].
	(self isInCycleX: xEntity y: yEntity) ifTrue: [ ^ self sccColor ].
	^ self dependencyColor
]

{ #category : #utilities }
MiDSMBrowserModel >> computeSCCs [
	"run tarjan"
	graph run
]

{ #category : #settings }
MiDSMBrowserModel >> defaultCellColor [

	^ nodeColors at: #defaultCell
]

{ #category : #settings }
MiDSMBrowserModel >> dependencyColor [
	"a 'nice' blue for cells with dependency"
	^ nodeColors at: #dependency
]

{ #category : #settings }
MiDSMBrowserModel >> diagonalCellColor [

	^nodeColors at: #diagonalCell
]

{ #category : #accessing }
MiDSMBrowserModel >> entities [
	^graph nodes collect: #model
]

{ #category : #utilities }
MiDSMBrowserModel >> entitiesOrdered [
	^(graph nodes sorted: [ :a :b |
		(a adjacentNodes size < b adjacentNodes size)
		ifTrue: [ true ]
		ifFalse: [ (a adjacentNodes size = b adjacentNodes size)
			ifTrue: [ a model name < b model name ]
			ifFalse: [ false ] ]
	]) collect: #model
]

{ #category : #testing }
MiDSMBrowserModel >> findNode: anEntity [

	^ "graph findNode: anEntity"
	nodeDictionary at: anEntity
]

{ #category : #actions }
MiDSMBrowserModel >> followEntity: aCollection [

	self newGraph.
	self buildGraphNodes: aCollection.
	self buildGraphEdges.
	self computeSCCs.
	browser buildDSM
]

{ #category : #accessing }
MiDSMBrowserModel >> highlightColorForX: xEntity y: yEntity [

	(self isInCycleX: xEntity y: yEntity) ifFalse: [ 
		^ self colorForX: xEntity y: yEntity ].
	^ self highlightSCCColor
]

{ #category : #actions }
MiDSMBrowserModel >> highlightEntity: anEntity [

	"browser highlightEntities: anEntity asCollection"
]

{ #category : #settings }
MiDSMBrowserModel >> highlightSCCColor [

	^ nodeColors at: #highlightSCC
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
	nodeColors at: #highlightSCC put: Color red.
	"extremely light gray for cell not in diagonal and not in dependency"
	nodeColors at: #defaultCell put: (Color r: 0.9 g: 0.9 b: 0.9).
	"a 'nice' blue for cells with dependency"
	nodeColors at: #dependency put: (Color colorFrom: '#4d79ff').

]

{ #category : #testing }
MiDSMBrowserModel >> isDependantX: xEntity onY: yEntity [

	^(self relationsForX: xEntity) includes: yEntity
]

{ #category : #testing }
MiDSMBrowserModel >> isDiagonalX: xEntity y: yEntity [
	^xEntity = yEntity

]

{ #category : #testing }
MiDSMBrowserModel >> isInCycleX: xEntity y: yEntity [

	^ (self findNode: xEntity) cycleNodes anySatisfy: [ :node | 
		  node model = yEntity ]
]

{ #category : #initialization }
MiDSMBrowserModel >> newGraph [
	graph := AITarjan new.
]

{ #category : #accessing }
MiDSMBrowserModel >> relationsForX: anEntity [

	^ (self findNode: anEntity) adjacentNodes collect: #model
]

{ #category : #settings }
MiDSMBrowserModel >> sccColor [

	^ nodeColors at: #scc
]

{ #category : #accessing }
MiDSMBrowserModel >> selectedEntities [
	^#()
]
