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
	self canvas @ RSCanvasController
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
