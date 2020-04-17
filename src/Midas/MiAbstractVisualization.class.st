Class {
	#name : #MiAbstractVisualization,
	#superclass : #Object,
	#instVars : [
		'theme',
		'canvas'
	],
	#category : #'Midas-Vizualisations'
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
MiAbstractVisualization >> theme [
	^ theme
]

{ #category : #accessing }
MiAbstractVisualization >> theme: anObject [
	theme := anObject
]
