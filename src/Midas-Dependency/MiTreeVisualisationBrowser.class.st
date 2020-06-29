"
Shows the containment tree (direct relations for now) between entities, as a roassal visualization.

- Follow:
Receives a MooseGroup.

- Highlight:
Entities if present.

- Propagate:
The selected entity if there is one.
"
Class {
	#name : #MiTreeVisualisationBrowser,
	#superclass : #MiAbstractDependencyBrowser,
	#instVars : [
		'diagram'
	],
	#category : #'Midas-Dependency-Tree'
}

{ #category : #specs }
MiTreeVisualisationBrowser class >> defaultSpec [
	^ super defaultSpec
		add: #diagram;
		yourself
]

{ #category : #specs }
MiTreeVisualisationBrowser class >> menuCommandOn: aBuilder [
	<worldMenu>
	(aBuilder item: #TreeVisualisationBrowser)
		parent: self toolbarDependencyName;
		label: self title;
		order: 2.0;
		icon: (self iconNamed: #mooseTree);
		action: [ self runMe ]
]

{ #category : #specs }
MiTreeVisualisationBrowser class >> runMe [
	<script>
	^ super runMe
]

{ #category : #'as yet unclassified' }
MiTreeVisualisationBrowser class >> title [
	^ 'Tree Visualisation'
]

{ #category : #'as yet unclassified' }
MiTreeVisualisationBrowser >> accept: anObject [
	^ anObject isMooseObject
]

{ #category : #script }
MiTreeVisualisationBrowser >> boxCompositeFor: cls [
	| label box composite |
	box := RSBox new
		size: 100;
		color: self theme selectionColor;
		yourself.
	label := RSLabel new
		text: cls name;
		color: self theme textColor;
		yourself.
	RSLocation new
		above;
		move: box on: label.
	composite := RSComposite new.
	composite
		shapes:
			{label.
			box};
		model: cls.
	composite @ RSDraggable.
	composite
		addInteraction: (MiSelection on: [ :entity | self model selected: entity ]).
	^ composite
]

{ #category : #script }
MiTreeVisualisationBrowser >> boxesForEntities [
	^ self model entities
		collect: [ :cls | self boxCompositeFor: cls ]
		as: RSGroup
]

{ #category : #script }
MiTreeVisualisationBrowser >> connectBoxes: boxes inCanvas: canvas [
	RSEdgeBuilder line
		canvas: canvas;
		shapes: boxes;
		withVerticalAttachPoint;
		connectToAll: [ :a | 
			(a usesFamixTrait: TEntityMetaLevelDependency)
				ifTrue: [ a children ]
				ifFalse: [ {} ] ].
	RSTreeLayout on: boxes
]

{ #category : #accessing }
MiTreeVisualisationBrowser >> diagram [
	^ diagram
]

{ #category : #accessing }
MiTreeVisualisationBrowser >> diagram: anObject [
	diagram := anObject
]

{ #category : #'as yet unclassified' }
MiTreeVisualisationBrowser >> followAction [
	((self accept: toSelect) and: [ self needUpdate: toSelect ])
		ifFalse: [ ^ self ].
	(toSelect isOfType: MooseGroup)
		ifTrue: [ self model entities: toSelect ]
		ifFalse: [ self model entities: {toSelect} ].
	self refresh
]

{ #category : #actions }
MiTreeVisualisationBrowser >> highlightAction [
	self refresh.
	(toSelect isOfType: MooseGroup)
		ifFalse: [ toSelect := {toSelect} ].
	diagram canvas nodes
		select: [ :box | toSelect includes: box model ]
		thenDo: [ :box | box shapes do: [ :shape | shape color: self theme warningTextColor  ] ].
	diagram canvas signalUpdate
]

{ #category : #initialization }
MiTreeVisualisationBrowser >> initializePresenters [
	super initializePresenters.
	self model: MiTreeVisualisationBrowserModel new.
	diagram := self instantiate: SpRoassalPresenter.
	diagram
		script: [ :canvas | canvas color: self theme backgroundColor ];
		refresh
]

{ #category : #script }
MiTreeVisualisationBrowser >> legendOn: canvas [
	| legend |
	legend := RSLegend new.
	legend container: canvas.
	legend onDemand: 'Legend'.
	legend build
]

{ #category : #accessing }
MiTreeVisualisationBrowser >> miSelectedItem [
	^ self model selected
]

{ #category : #script }
MiTreeVisualisationBrowser >> refresh [
	diagram
		script: [ :canvas | 
			| boxes |
			canvas color: self theme backgroundColor.
			boxes := self boxesForEntities.
			canvas addAll: boxes.
			self connectBoxes: boxes inCanvas: canvas.
			canvas @ RSCanvasController.
			canvas ];
		refresh
]
