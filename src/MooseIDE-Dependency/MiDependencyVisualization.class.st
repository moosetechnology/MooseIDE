"
Roassal visualization for MiDependencyBrowser
"
Class {
	#name : #MiDependencyVisualization,
	#superclass : #MiAbstractVisualization,
	#instVars : [
		'entities',
		'selected',
		'incomingDependencies',
		'outgoingDependencies'
	],
	#category : #'MooseIDE-Dependency-Dependency'
}

{ #category : #running }
MiDependencyVisualization >> buildDependencyLinks [
	RSEdgeBuilder arrowedLine
		canvas: self canvas;
		withBorderAttachPoint;
		color: self theme textColor;
		source: self entities
			connectFrom: #yourself
			toAll:
				[ :p | (outgoingDependencies at: p) asSet	", (outgoingDependencies at: p)" ]
]

{ #category : #running }
MiDependencyVisualization >> collectDependencies [
	incomingDependencies := Dictionary new.
	outgoingDependencies := Dictionary new.
	self entities
		do: [ :each | 
			incomingDependencies
				at: each
				put:
					(each queryAllIncoming withoutSelfLoops atScope: each class)
						asOrderedCollection.
			outgoingDependencies
				at: each
				put:
					(each queryAllOutgoing withoutSelfLoops atScope: each class)
						asOrderedCollection ]
]

{ #category : #running }
MiDependencyVisualization >> colorForEdge: edge ofShape: shape [
	| dependency |
	dependency := edge model key = shape model
		ifTrue: [ edge model value ]
		ifFalse: [ edge model key ].
	^ ((incomingDependencies at: shape model) includes: dependency)
		ifTrue: [ ((outgoingDependencies at: shape model) includes: dependency)
				ifTrue: [ "Incoming and outgoing" Color red ]
				ifFalse: [ "Incoming" Color green ] ]
		ifFalse: [ "Outgoing" Color blue ]
]

{ #category : #running }
MiDependencyVisualization >> colorScale [
	^ NSScale linear
		domain: #(1 500);
		range:
			{Color white.
			Color darkGray}
]

{ #category : #accessing }
MiDependencyVisualization >> entities [
	^ entities
]

{ #category : #accessing }
MiDependencyVisualization >> entities: aCollection [
	entities := aCollection
]

{ #category : #highlighting }
MiDependencyVisualization >> highlightShapes [
	"It would be interesting to color edges as well but we have to choose a behavior: 
			when only one of the source & target is highlighted VS when both are highlighted"

	self canvas nodes
		do: [ :box | box color: (self colorFor: box model) ]
]

{ #category : #initialization }
MiDependencyVisualization >> initialize [

	super initialize.
	entities := MooseGroup new
]

{ #category : #legend }
MiDependencyVisualization >> legend [
	self
		withLegend: [ :b | 
			b title: 'Dependency'.
			b
				text: 'Number of lines of code'
				withFadingRamp:
					{(0 -> 'white').
					(1 -> 'black')}.
			b
				polymetricWidth: 'number of incoming dependencies'
				height: 'number of outgoing dependencies'
				box: 'Entity'.
			b text: 'Outgoing' withShape: (self legendArrowColored: Color blue).
			b
				text: 'Incoming'
				withShape: (self legendArrowColored: Color green).
			b text: 'Both' withShape: (self legendArrowColored: Color red).
			b
				legendDo: [ :s | 
					s
						color: (Color white alpha: 0.8);
						scaleBy: 0.7;
						padding: 15 ] ]
]

{ #category : #legend }
MiDependencyVisualization >> legendArrowColored: aColor [
	^ RSLine new
		startPoint: 0 @ 0;
		endPoint: 20 @ 0;
		color: aColor;
		yourself
]

{ #category : #running }
MiDependencyVisualization >> makeHighlightable: shape [
	shape
		@
			(RSHighlightable new
				withEdges;
				highlightColor: [ :edge | 
					edge = shape
						ifTrue: [ self highlightColor ]
						ifFalse: [ self colorForEdge: edge ofShape: shape ] ])
]

{ #category : #helpers }
MiDependencyVisualization >> noHighlightColorFor: anEntity [
	^ self colorScale scale: anEntity numberOfLinesOfCode
]

{ #category : #running }
MiDependencyVisualization >> run [
	| shapes |
	super run.
	self collectDependencies.
	shapes := self entities
		collect: [ :node | self shapeForEntity: node ]
		as: RSGroup.
	self canvas addAll: shapes.
	self buildDependencyLinks.
	RSCircleLayout new on: shapes.
	self legend.
	self canvas zoomToFit
]

{ #category : #accessing }
MiDependencyVisualization >> selected [
	^ selected
]

{ #category : #accessing }
MiDependencyVisualization >> selected: anObject [
	selected := anObject
]

{ #category : #running }
MiDependencyVisualization >> shapeForEntity: node [

	| shape |
	shape := RSBox new
		         color: (self colorScale scale: node numberOfLinesOfCode);
		         "+5 for a minimal size"width:
			         (incomingDependencies at: node) size * 2 + 5;
		         height: (outgoingDependencies at: node) size * 2 + 5;
		         model: node;
		         popup;
		         draggable;
		         addInteraction: ((MiSelection on: [ :entity | 
					           self selected: entity.
					           owner updateToolbar ]) marginPercentage: 0.5);
		         yourself.
	self makeHighlightable: shape.
	^ shape
]
