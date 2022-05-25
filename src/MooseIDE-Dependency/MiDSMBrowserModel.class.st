"
A model for the MiDSMBrowser, contains the entities to display, computes the dependencies and the colors to show the cells of the DSM matrix
"
Class {
	#name : #MiDSMBrowserModel,
	#superclass : #Object,
	#instVars : [
		'browser',
		'graph'
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
MiDSMBrowserModel >> buildGraph [
	"RSDSM conventions: X entities are at the top of the matricx, Y entities at the left
	We choose to say that there is a relation from X to Y if Y depends on X"
	| entities |
	entities := self entities.
	entities do: [ :entity |
		graph
			edges: { entity }
			from: #yourself
			toAll: [ :sourceEntity |
				(sourceEntity queryAllIncoming withoutSelfLoops atScope: sourceEntity class) intersection: entities
			]
	]
]

{ #category : #testing }
MiDSMBrowserModel >> canFollowEntity: anObject [

	^ anObject isCollection and: [ 
		  anObject allSatisfy: [ :a | 
			  a usesFamixTrait: TEntityMetaLevelDependency ] ].
]

{ #category : #accessing }
MiDSMBrowserModel >> colorForX: xEntity y: yEntity [
	(self isDiagonalX: xEntity y: yEntity)
	ifTrue: [ ^Color veryLightGray ].
	(self isDependantX: xEntity onY: yEntity)
	ifFalse: [ ^Color r: 0.9 g: 0.9 b: 0.9 "extremely light gray" ].
	(self isInCycleX: xEntity y: yEntity)
	ifTrue: [ ^Color lightRed ].
	^Color colorFrom: '#4d79ff'
]

{ #category : #utilities }
MiDSMBrowserModel >> computeSCCs [
	graph run
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

{ #category : #actions }
MiDSMBrowserModel >> followEntity: aCollection [
	self newGraph.
	graph nodes: (aCollection asMooseGroup select: [ :e | 
		e usesFamixTrait: TEntityMetaLevelDependency ]).
	self buildGraph.
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
	self newGraph 
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

	^(graph findNode: xEntity) cycleNodes anySatisfy: [ :node | node model = yEntity ]
]

{ #category : #initialization }
MiDSMBrowserModel >> newGraph [
	graph := AITarjan new.
]

{ #category : #accessing }
MiDSMBrowserModel >> relationsForX: anEntity [

	^(graph findNode: anEntity) adjacentNodes collect: #model
]

{ #category : #accessing }
MiDSMBrowserModel >> selectedEntities [
	^#()
]
