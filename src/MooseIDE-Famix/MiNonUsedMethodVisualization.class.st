Class {
	#name : #MiNonUsedMethodVisualization,
	#superclass : #MiAbstractVisualization,
	#category : #'MooseIDE-Famix-SourceText'
}

{ #category : #running }
MiNonUsedMethodVisualization >> run [

	| boxes |
	super run.
	self canvas color: self theme backgroundColor.
	boxes := self owner model deadMethods collect: [ :method | 
		         self shapeForEntity: method ].
	self canvas addAll: boxes.
	RSGridLayout on: boxes.
	self canvas zoomToFit
]

{ #category : #building }
MiNonUsedMethodVisualization >> shapeForEntity: aMethod [

	| label box composite |
	box := RSBox new
		       size: 100;
		       color: self theme selectionColor.
	label := RSLabel new
		         text: aMethod name;
		         color: self theme textColor.
	RSLocation new
		above;
		move: box on: label.
	composite := RSComposite new.
	composite
		shapes: { 
				label.
				box };
		model: aMethod.
	composite @ RSDraggable.
	^ composite
]
