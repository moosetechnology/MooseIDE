Class {
	#name : #MiAbstractVisualization,
	#superclass : #SpRoassalPresenter,
	#instVars : [
		'highlightedEntities'
	],
	#category : #'MooseIDE-Visualization-Helpers'
}

{ #category : #helpers }
MiAbstractVisualization >> colorFor: anEntity [
	^ (highlightedEntities includes: anEntity)
		ifTrue: [ self highlightColor ]
		ifFalse: [ self noHighlightColorFor: anEntity ]
]

{ #category : #helpers }
MiAbstractVisualization >> highlightColor [
	^ self theme warningTextColor
]

{ #category : #highlighting }
MiAbstractVisualization >> highlightEntities: someEntities [

	self highlightedEntities: someEntities asMooseGroup.
	self highlightShapes.
	self canvas signalUpdate
]

{ #category : #highlighting }
MiAbstractVisualization >> highlightShapes [

	self selectShapes: (self shapesWithModel: [ :shape | shape model ])
]

{ #category : #accessing }
MiAbstractVisualization >> highlightedEntities [
	^ highlightedEntities
]

{ #category : #accessing }
MiAbstractVisualization >> highlightedEntities: entities [
	highlightedEntities := entities
]

{ #category : #initialization }
MiAbstractVisualization >> initialize [
	super initialize.
	highlightedEntities := MooseGroup new.
	self script: [ :canvas | canvas @ RSCanvasController new noLegend ]
]

{ #category : #accessing }
MiAbstractVisualization >> miSelectedItem [

	^ self canvas selectedShapes collect: [ :shape | shape model ]
]

{ #category : #helpers }
MiAbstractVisualization >> noHighlightColorFor: anEntity [
	^ self theme selectionColor
]

{ #category : #running }
MiAbstractVisualization >> run [
	self refresh
]

{ #category : #highlighting }
MiAbstractVisualization >> selectShapes: shapes [

	self canvas setSelectedShapes: shapes
]

{ #category : #highlighting }
MiAbstractVisualization >> shapesWithModel: aBlock [
	"aBlock should return the model of a shape."
	^ self canvas shapes select: [ :shape |
		  shape isLine not and: [
			  shape model notNil and: [
				  highlightedEntities includes: (aBlock value: shape) ] ] ]
]

{ #category : #highlighting }
MiAbstractVisualization >> unHighlight [
	highlightedEntities := MooseGroup new
]

{ #category : #helpers }
MiAbstractVisualization >> withLegend: aBlock [
	| b |
	b := RSLegend new.
	b container: self canvas.
	b defaultTitle fontSize: 12.
	b defaultLabel fontSize: 10.
	b defaultBoldText fontSize: 10.
	aBlock value: b.
	b onDemand: 'Legend'.
	b build
]
