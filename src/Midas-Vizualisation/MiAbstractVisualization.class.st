Class {
	#name : #MiAbstractVisualization,
	#superclass : #SpRoassalPresenter,
	#instVars : [
		'highlightedEntities'
	],
	#category : #'Midas-Vizualisation'
}

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
	highlightedEntities := MooseGroup new.
	self script: [ :canvas | canvas @ RSCanvasController new noLegend ]
]

{ #category : #running }
MiAbstractVisualization >> run [
	self subclassResponsibility
]

{ #category : #highlighting }
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
