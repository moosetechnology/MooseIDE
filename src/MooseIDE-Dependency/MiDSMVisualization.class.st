"
A visualization of a RSDSM inside a MooseIDE browser
"
Class {
	#name : #MiDSMVisualization,
	#superclass : #MiAbstractVisualization,
	#instVars : [
		'entities',
		'selected',
		'depending'
	],
	#category : #'MooseIDE-Dependency-DSM'
}

{ #category : #utilities }
MiDSMVisualization >> collectDependencies [

	depending := Dictionary new.
	self entities do: [ :each | 
		depending
			at: each
			put: ((each queryAllIncoming withoutSelfLoops atScope: each class) intersection: self entities) ]
]

{ #category : #utilities }
MiDSMVisualization >> colorFor: tuple [
	(self isDiagonal: tuple)
	ifTrue: [ ^Color veryLightGray ].
	(self isDependency: tuple)
	ifTrue: [ ^Color colorFrom: '#4d79ff' "nice blue" ].
	^Color r: 0.9 g: 0.9 b: 0.9 "extremely light gray"
	
]

{ #category : #accessing }
MiDSMVisualization >> createDSM: aRSCanvas [
	| dsm |
	self flag: #FIXME. "We still need fill correctly objects and dependency with incomingDependencies and outgoingDependencies calculated in #collectDependencies"
	entities ifEmpty: [ ^ self ].
	self collectDependencies.

	aRSCanvas addInteraction: RSCanvasController new noLegend. "replace with 
	RSLegend new ..."
	dsm := RSDSM new.
	dsm labelShapeX textBlock: #name.
	dsm labelShapeY textBlock: #name.
	dsm container: aRSCanvas.
	dsm objects: (self orderedEntities: entities).
	dsm dependency: [ :entity | self dependingOn: entity ].
	dsm color: [ :tuple | self colorFor: tuple ].
	dsm build
]

{ #category : #utilities }
MiDSMVisualization >> dependenciesFrom: entity [

	^depending at: entity
]

{ #category : #utilities }
MiDSMVisualization >> dependingOn: entity [

	^depending at: entity
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

{ #category : #utilities }
MiDSMVisualization >> isDependency: tuple [
	^(depending at: tuple key) includes: tuple value
]

{ #category : #utilities }
MiDSMVisualization >> isDiagonal: tuple [
	^tuple key = tuple value
]

{ #category : #utilities }
MiDSMVisualization >> orderedEntities: aCollection [
	^aCollection sorted: [ :a :b || dependenciesA dependenciesB |
		dependenciesA := depending at: a.
		dependenciesB := depending at: b.
		(dependenciesA size < dependenciesB size)
		ifTrue: [ true ]
		ifFalse: [ (dependenciesA size = dependenciesB size)
			ifTrue: [ a name < b name ]
			ifFalse: [ false ] ]
	]
]

{ #category : #accessing }
MiDSMVisualization >> selected [

	^ selected
]

{ #category : #accessing }
MiDSMVisualization >> selected: anObject [

	selected := anObject
]
