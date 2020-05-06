Class {
	#name : #MiDependencyVisualization,
	#superclass : #MiAbstractVisualization,
	#instVars : [
		'diagram',
		'entities'
	],
	#category : #'Midas-Dependency-Dependency'
}

{ #category : #running }
MiDependencyVisualization >> entities [
	^ entities
]

{ #category : #running }
MiDependencyVisualization >> entities: aCollection [
	entities := aCollection
]

{ #category : #running }
MiDependencyVisualization >> initialize [
	super initialize.
	
	entities := #().
]

{ #category : #running }
MiDependencyVisualization >> run [
	| nodes shapes nodesOutgoing nodesIncoming |
	nodes := self entities.
	nodesIncoming := Dictionary new.
	nodesOutgoing := Dictionary new.
	nodes
		do: [ :each | 
			nodesIncoming at: each put: (each queryIncomingDependencies withoutSelfLoops atScope: FamixTNamespace) asOrderedCollection.
			nodesOutgoing at: each put: (each queryOutgoingDependencies withoutSelfLoops atScope: FamixTNamespace) asOrderedCollection ].
	shapes := nodes
		collect: [ :node | 
			RSBox new
				color: Color white;
				width: (nodesIncoming at: node) size * 2 ;
				height: [ :p | (nodesOutgoing at: p) size * 2 ];
				yourself ].
	self canvas addAll: shapes.
	RSWeightedCircleLayout new initialRadius: 300; on: shapes.
	self canvas zoomToFit
]
