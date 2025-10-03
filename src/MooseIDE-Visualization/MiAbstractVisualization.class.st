Class {
	#name : 'MiAbstractVisualization',
	#superclass : 'SpRoassalPresenter',
	#instVars : [
		'highlightedEntities'
	],
	#category : 'MooseIDE-Visualization-Helpers',
	#package : 'MooseIDE-Visualization',
	#tag : 'Helpers'
}

{ #category : 'running' }
MiAbstractVisualization >> buildInCanvas: aCanvas [

	self subclassResponsibility
]

{ #category : 'running' }
MiAbstractVisualization >> clearLegend [

	^ self canvas fixedShapes: RSGroup new
]

{ #category : 'helpers' }
MiAbstractVisualization >> colorFor: anEntity [
	^ (highlightedEntities includes: anEntity)
		ifTrue: [ self highlightColor ]
		ifFalse: [ self noHighlightColorFor: anEntity ]
]

{ #category : 'helpers' }
MiAbstractVisualization >> highlightColor [
	^ self theme warningTextColor
]

{ #category : 'highlighting' }
MiAbstractVisualization >> highlightEntities: someEntities [

	self canvas shapes ifEmpty: [ ^ self ].
	self highlightedEntities: someEntities asMooseGroup.
	self highlightShapes.
	self canvas signalUpdate
]

{ #category : 'highlighting' }
MiAbstractVisualization >> highlightShapes [

	self selectShapes: self shapesWithModel
]

{ #category : 'accessing' }
MiAbstractVisualization >> highlightedEntities [
	^ highlightedEntities
]

{ #category : 'accessing' }
MiAbstractVisualization >> highlightedEntities: entities [
	highlightedEntities := entities
]

{ #category : 'initialization' }
MiAbstractVisualization >> initialize [

	super initialize.

	highlightedEntities := MooseGroup new.

	self script: [ :canvas | self buildInCanvas: canvas ]
]

{ #category : 'accessing' }
MiAbstractVisualization >> miSelectedItem [

	^ self canvas selectedShapes collect: [ :shape | self modelForShape: shape ]
]

{ #category : 'accessing' }
MiAbstractVisualization >> modelForShape: aShape [

	^ aShape model
]

{ #category : 'helpers' }
MiAbstractVisualization >> noHighlightColorFor: anEntity [
	^ self theme selectionColor
]

{ #category : 'running' }
MiAbstractVisualization >> run [

	self canvas clear.
	self clearLegend.
	self canvas controllerInteraction: nil.
	self script value: self canvas
]

{ #category : 'highlighting' }
MiAbstractVisualization >> selectShapes: shapes [

	self canvas setSelectedShapes: shapes
]

{ #category : 'highlighting' }
MiAbstractVisualization >> shapesWithModel [

	^ self canvas shapes select: [ :shape |
			  shape isLine not and: [
					  shape model notNil and: [
						  highlightedEntities includes: (self modelForShape: shape) ] ] ]
]

{ #category : 'highlighting' }
MiAbstractVisualization >> unHighlight [
	highlightedEntities := MooseGroup new
]
