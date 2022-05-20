Class {
	#name : #MiDSMVisualization,
	#superclass : #MiAbstractVisualization,
	#instVars : [
		'entities',
		'selected',
		'incomingDependencies',
		'outgoingDependencies'
	],
	#category : #'MooseIDE-Dependency-Dependency'
}

{ #category : #utilities }
MiDSMVisualization >> collectDependencies [

	incomingDependencies := Dictionary new.
	outgoingDependencies := Dictionary new.
	self entities do: [ :each | 
		incomingDependencies
			at: each
			put: (each queryAllIncoming withoutSelfLoops atScope: each class)
					asOrderedCollection.
		outgoingDependencies
			at: each
			put: (each queryAllOutgoing withoutSelfLoops atScope: each class)
					asOrderedCollection ]
]

{ #category : #accessing }
MiDSMVisualization >> createDSM: aRSCanvas [
	| dsm |
	self flag: #FIXME. "We still need fill correctly objects and dependency with incomingDependencies and outgoingDependencies calculated in #collectDependencies"
	entities ifEmpty: [ ^ self ].
	self collectDependencies.

	aRSCanvas addInteraction: RSCanvasController new.
	dsm := RSDSM new.
	dsm labelShapeX textBlock: #name.
	dsm labelShapeY textBlock: #name.
	dsm container: aRSCanvas.
	dsm objects: entities.
	dsm dependency: [ :entity | self dependenciesFrom: entity ].
	dsm build
]

{ #category : #utility }
MiDSMVisualization >> dependenciesFrom: entity [

	"entity name = #String ifTrue: [ 1 halt ]."

	^ entity allProviders
]

{ #category : #accessing }
MiDSMVisualization >> entities [

	^ entities
]

{ #category : #accessing }
MiDSMVisualization >> entities: anObject [

	entities := anObject
]

{ #category : #highlighting }
MiDSMVisualization >> highlightShapes [

	^ #(  )
]

{ #category : #initialization }
MiDSMVisualization >> initialize [

	super initialize.
	self script: [ :canvas | self createDSM: canvas ].
	entities := MooseGroup new
]

{ #category : #accessing }
MiDSMVisualization >> selected [

	^ selected
]

{ #category : #accessing }
MiDSMVisualization >> selected: anObject [

	selected := anObject
]
