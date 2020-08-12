Class {
	#name : #MiTreeVisualisation,
	#superclass : #MiAbstractVisualization,
	#instVars : [
		'selected',
		'entities'
	],
	#category : #'Midas-Dependency-Tree'
}

{ #category : #running }
MiTreeVisualisation >> boxCompositeFor: cls [
	| label box |
	box := self newBox.
	label := self newLabel: cls name.
	RSLocation new
		above;
		move: box on: label.
	^ RSComposite new
		shapes:
			{label.
			box};
		model: cls;
		@ RSDraggable;
		addInteraction: (MiSelection on: [ :entity | self selected: entity ]);
		yourself
]

{ #category : #running }
MiTreeVisualisation >> connectBoxes: boxes inCanvas: canvas [
	self canvas addAll: boxes.
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
MiTreeVisualisation >> entities [
	^ entities
]

{ #category : #accessing }
MiTreeVisualisation >> entities: anObject [
	entities := anObject
]

{ #category : #running }
MiTreeVisualisation >> newBox [
	^ RSBox new
		size: 100;
		color: self theme selectionColor;
		yourself
]

{ #category : #running }
MiTreeVisualisation >> newLabel: name [
	^ RSLabel new
		text: name;
		color: self theme textColor;
		yourself
]

{ #category : #updating }
MiTreeVisualisation >> refreshShapes [
	self canvas nodes
		do:
			[ :box | box shapes do: [ :shape | shape color: (self colorFor: box model) ] ]
]

{ #category : #running }
MiTreeVisualisation >> run [
	super run.
	self
		connectBoxes: (entities collect: [ :cls | self boxCompositeFor: cls ])
		inCanvas: self canvas.
	self canvas zoomToFit
]

{ #category : #accessing }
MiTreeVisualisation >> selected [
	^ selected
]

{ #category : #accessing }
MiTreeVisualisation >> selected: anObject [
	selected := anObject
]
