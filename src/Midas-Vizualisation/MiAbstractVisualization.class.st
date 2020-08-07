Class {
	#name : #MiAbstractVisualization,
	#superclass : #Object,
	#instVars : [
		'theme',
		'canvas',
		'highlightedEntities'
	],
	#category : #'Midas-Vizualisation'
}

{ #category : #accessing }
MiAbstractVisualization >> canvas [
	^ canvas
]

{ #category : #accessing }
MiAbstractVisualization >> canvas: anObject [
	canvas := anObject.
	self defaultActionOnCanvas
]

{ #category : #accessing }
MiAbstractVisualization >> defaultActionOnCanvas [
	self canvas @ RSCanvasController new noLegend
]

{ #category : #highlighting }
MiAbstractVisualization >> highlightColor [
	^ self theme warningTextColor
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
	highlightedEntities := MooseGroup new
]

{ #category : #accessing }
MiAbstractVisualization >> theme [
	^ theme
]

{ #category : #accessing }
MiAbstractVisualization >> theme: anObject [
	theme := anObject
]

{ #category : #initialization }
MiAbstractVisualization >> unHighlight [
	highlightedEntities := MooseGroup new
]

{ #category : #accessing }
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
