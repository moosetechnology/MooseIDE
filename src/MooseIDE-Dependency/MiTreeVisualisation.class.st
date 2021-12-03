Class {
	#name : #MiTreeVisualisation,
	#superclass : #MiAbstractVisualization,
	#category : #'MooseIDE-Dependency-Tree'
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
		  shapes: { 
				  label.
				  box };
		  model: cls;
		  @ RSDraggable;
		  addInteraction:
			  (MiSelection on: [ :entity | self owner model selected: entity ]);
		  yourself
]

{ #category : #running }
MiTreeVisualisation >> connectBoxes: boxes inCanvas: canvas [

	self canvas addAll: boxes.
	RSEdgeBuilder line
		canvas: canvas;
		shapes: boxes;
		withVerticalAttachPoint;
		connectToAll: [ :entity | entity children ].
	RSTreeLayout on: boxes
]

{ #category : #updating }
MiTreeVisualisation >> highlightShapes [

	self canvas nodes do: [ :box | 
		box shapes do: [ :shape | shape color: (self colorFor: box model) ] ]
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

{ #category : #accessing }
MiTreeVisualisation >> receiveEntity: anEntity [

	(self canvas nodes shapeFromModel: anEntity) click
]

{ #category : #running }
MiTreeVisualisation >> run [

	super run.
	self unHighlight.
	self
		connectBoxes: (self owner model entities collect: [ :entity | 
				 self boxCompositeFor: entity ])
		inCanvas: self canvas.
	self canvas zoomToFit
]
