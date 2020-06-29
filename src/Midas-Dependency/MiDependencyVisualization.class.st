"
Roassal visualization for MiDependencyBrowser
"
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
		select: [ :a | a usesFamixTrait: TEntityMetaLevelDependency ]
]

{ #category : #running }
MiDependencyVisualization >> initialize [
	super initialize.
	
	entities := #().
]

{ #category : #running }
MiDependencyVisualization >> legend [
	| line |
	self
		withLegend: [ :b | 
			b title: 'Dependency'.
			b text: 'Number of lines of code' withFadingRamp: {(0 -> 'white') . (1 -> 'black')}.
			b polymetricWidth: 'number of incoming dependency' height: 'number of outgoing dependency' box: 'an entity'.
			b
				leyendDo: [ :s | 
					s
						draggable;
						border:
							(RSBorder new
								color: Color red;
								dashArray: #(4));
						color: (Color white alpha: 0.8);
						scaleBy: 0.5;
						padding: 15 ].
			b location right middle.
			line := RSLine new
				startPoint: 0 @ 0;
				endPoint: 20 @ 0;
				color: Color blue yourself.
			b text: 'Outgoing' withShape: line.
			line := RSLine new
				startPoint: 0 @ 0;
				endPoint: 20 @ 0;
				color: Color green yourself.
			b text: 'Incoming' withShape: line.
			line := RSLine new
				startPoint: 0 @ 0;
				endPoint: 20 @ 0;
				color: Color red yourself.
			b text: 'Both' withShape: line ]
]

{ #category : #running }
MiDependencyVisualization >> run [
	| nodes shapes nodesOutgoing nodesIncoming high color |
	nodes := self entities.
	nodesIncoming := Dictionary new.
	nodesOutgoing := Dictionary new.
	nodes
		do: [ :each | 
			nodesIncoming
				at: each
				put:
					(each queryAllIncoming withoutSelfLoops atScope: each class)
						asOrderedCollection.
			nodesOutgoing
				at: each
				put:
					(each queryAllOutgoing withoutSelfLoops atScope: each class)
						asOrderedCollection ].
	color := NSScale linear
		domain: #(1 500);
		range:
			{Color white.
			Color darkGray}.
	shapes := nodes
		collect: [ :node | 
			RSComposite new
				shapes:
					{(RSBox new
						color: (color scale: node numberOfLinesOfCode);
						"+5 for a minimal size"
							width: (nodesIncoming at: node) size * 2 + 5;
						height: (nodesOutgoing at: node) size * 2 + 5;
						yourself)};
				model: node;
				popup;
				draggable;
				yourself ]
		as: RSGroup.
	shapes
		do: [ :shape | 
			high := RSHighlightable new.
			high withEdges.
			high
				highlightColor: [ :edge | 
					edge = shape
						ifTrue: [ Color yellow ]
						ifFalse: [ | each value |
							"Is it an outgoingEdge or an incomingEdge"
							edge model key = shape model
								ifTrue: [ each := edge model key.
									value := edge model value ]
								ifFalse: [ each := edge model value.
									value := edge model key ].
							((nodesIncoming at: each) includes: value)
								ifTrue: [ ((nodesOutgoing at: each) includes: value)
										ifTrue: [ Color red ]
										ifFalse: [ Color green ] ]
								ifFalse: [ Color blue ] ] ].
			shape @ high ].
	self canvas addAll: shapes.
	RSEdgeBuilder bimetricLine
		canvas: canvas;
		objects: nodes;
		color: Color lightGray;
		noBorder;
		withBorderAttachPoint;
		widthFrom: 1;
		widthTo: 1;
		connectFrom: #yourself
			toAll: [ :p | ((nodesIncoming at: p) , (nodesOutgoing at: p)) asSet ].
	RSCircleLayout new on: shapes.
	self legend.
	self canvas zoomToFit
]
