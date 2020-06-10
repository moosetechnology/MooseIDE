"
I am a Roassal representation of a sequence with arrowed shapes.

I open on a collection of models.

Users can configure:
	- The extent of the shapes (a Point)
	- The color, label and popup text of each shape (a Block with each model as arguement).

Example: 

'| presenter |
	presenter := (FQRoassalSequence on: { 1. 2. 3 })
		shapeColor: [ :model | 
			{Color yellow.
			Color orange.
			Color red} at: model ];
		shapeLabel: [ :model | model asString ];
		shapePopup: [ :model | {'One' . 'Two' . 'Three'} at: model ].
	presenter openWithSpec'
"
Class {
	#name : #MiRoassalSequence,
	#superclass : #SpRoassalPresenter,
	#instVars : [
		'models',
		'shapeExtent',
		'shapeColor',
		'shapeLabel',
		'shapePopup'
	],
	#category : #'Midas-FamixQueries-Widgets'
}

{ #category : #specs }
MiRoassalSequence class >> title [
	^ 'Roassal Sequence'
]

{ #category : #default }
MiRoassalSequence >> defaultShapeColor [
	^ [ :model | Color gray ]
]

{ #category : #default }
MiRoassalSequence >> defaultShapeExtent [
	^ 100 @ self class toolbarHeight
]

{ #category : #default }
MiRoassalSequence >> defaultShapeLabel [
	^ [ :model | '' ]
]

{ #category : #initialization }
MiRoassalSequence >> initialize [
	super initialize.
	self initializeScript
]

{ #category : #initialization }
MiRoassalSequence >> initializeScript [
	self script: [ :canvas | self sequenceScriptOn: canvas ]
]

{ #category : #'private - script' }
MiRoassalSequence >> label [
	| label |
	label := RSLabeled new text: self shapeLabel.
	label location
		inner;
		center;
		middle.
	^ label
]

{ #category : #'private - script' }
MiRoassalSequence >> newArrowedShape [
	| offset points |
	offset := 0.6.
	points := {(-1 @ -1).
	(offset @ -1).
	(1 @ 0).
	(offset @ 1).
	(-1 @ 1).
	(offset negated @ 0)}.
	^ RSShapeFactory polygonWithPoints: points
]

{ #category : #'private - script' }
MiRoassalSequence >> newArrowedShapeFor: model position: i [
	| shape |
	shape := self newArrowedShape
		model: model;
		extent: self shapeExtent;
		color: (self shapeColor value: model);
		addInteraction: self label;
		position: ((i - 1) * self shapeExtent x) @ 0.
	self shapePopup
		ifNotNil: [ shape popupText: (self shapePopup value: model) ].
	^ shape
]

{ #category : #'private - script' }
MiRoassalSequence >> sequenceScriptOn: canvas [
	models
		withIndexDo:
			[ :model :i | canvas add: (self newArrowedShapeFor: model position: i) ].
	canvas @ RSCanvasController new noLegend.
	^ canvas
]

{ #category : #'accessing model' }
MiRoassalSequence >> setModelBeforeInitialization: aCollectionOfModelObjects [
	models := aCollectionOfModelObjects
]

{ #category : #'accessing model' }
MiRoassalSequence >> setModels: aCollection [
	models := aCollection.
	self refresh
]

{ #category : #accessing }
MiRoassalSequence >> shapeColor [
	^ shapeColor ifNil: [ self defaultShapeColor ]
]

{ #category : #accessing }
MiRoassalSequence >> shapeColor: anObject [
	shapeColor := anObject
]

{ #category : #accessing }
MiRoassalSequence >> shapeExtent [
	^ shapeExtent ifNil: [ self defaultShapeExtent ]
]

{ #category : #accessing }
MiRoassalSequence >> shapeExtent: anObject [
	shapeExtent := anObject
]

{ #category : #accessing }
MiRoassalSequence >> shapeLabel [
	^ shapeLabel ifNil: [ self defaultShapeLabel ]
]

{ #category : #accessing }
MiRoassalSequence >> shapeLabel: anObject [
	shapeLabel := anObject
]

{ #category : #accessing }
MiRoassalSequence >> shapePopup [
	^ shapePopup
]

{ #category : #accessing }
MiRoassalSequence >> shapePopup: anObject [
	shapePopup := anObject
]
