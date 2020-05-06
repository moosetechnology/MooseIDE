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
	| nodes shapes nodesOutgoing nodesIncoming high |
	nodes := self entities.
	nodesIncoming := Dictionary new.
	nodesOutgoing := Dictionary new.
	nodes
		do: [ :each | 
			nodesIncoming at: each put: (each queryIncomingDependencies withoutSelfLoops atScope: FamixTNamespace) asOrderedCollection.
			nodesOutgoing at: each put: (each queryOutgoingDependencies withoutSelfLoops atScope: FamixTNamespace) asOrderedCollection ].
	shapes := nodes
		collect: [ :node | 
			RSComposite new
				shapes:
					{(RSBox new
						color: Color white;
						width: (nodesIncoming at: node) size * 2;
						height: (nodesOutgoing at: node) size * 2;
						yourself)};
				model: node;
				draggable;
				yourself ]
		as: RSGroup.
	high := RSHighlightable new.
	high withEdges.
	high highlightColor: Color red translucent.
	shapes @ high.
	self canvas addAll: shapes.
	RSEdgeBuilder bimetricLine
		canvas: canvas;
		objects: nodes;
		color: Color lightGray;
		noBorder;
		withBorderAttachPoint;
		widthFrom: 1;
		widthTo: 1;
		connectFrom: #yourself toAll: [ :p | ((nodesIncoming at: p) , (nodesOutgoing at: p)) asSet ].
	RSCircleLayout new on: shapes.
	self canvas zoomToFit
]
