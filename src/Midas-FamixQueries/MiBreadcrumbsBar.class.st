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
	#name : #MiBreadcrumbsBar,
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
MiBreadcrumbsBar class >> title [
	^ 'Roassal Sequence'
]

{ #category : #default }
MiBreadcrumbsBar >> defaultShapeColor [
	^ [ :model | Color gray ]
]

{ #category : #default }
MiBreadcrumbsBar >> defaultShapeExtent [
	^ 100 @ self class toolbarHeight
]

{ #category : #default }
MiBreadcrumbsBar >> defaultShapeLabel [
	^ [ :model | '' ]
]

{ #category : #initialization }
MiBreadcrumbsBar >> initialize [
	super initialize.
	self initializeScript
]

{ #category : #initialization }
MiBreadcrumbsBar >> initializeScript [
	self script: [ :canvas | self sequenceScriptOn: canvas ]
]

{ #category : #'private - script' }
MiBreadcrumbsBar >> label [
	| label |
	label := RSLabeled new text: self shapeLabel.
	label location
		inner;
		center;
		middle.
	^ label
]

{ #category : #'private - script' }
MiBreadcrumbsBar >> newArrowedShape [
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
MiBreadcrumbsBar >> newArrowedShapeFor: model position: i [
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
MiBreadcrumbsBar >> sequenceScriptOn: canvas [
	models
		withIndexDo:
			[ :model :i | canvas add: (self newArrowedShapeFor: model position: i) ].
	canvas @ RSCanvasController new noLegend.
	^ canvas
]

{ #category : #'accessing model' }
MiBreadcrumbsBar >> setModelBeforeInitialization: aCollectionOfModelObjects [
	models := aCollectionOfModelObjects
]

{ #category : #'accessing model' }
MiBreadcrumbsBar >> setModels: aCollection [
	models := aCollection.
	self refresh
]

{ #category : #accessing }
MiBreadcrumbsBar >> shapeColor [
	^ shapeColor ifNil: [ self defaultShapeColor ]
]

{ #category : #accessing }
MiBreadcrumbsBar >> shapeColor: anObject [
	shapeColor := anObject
]

{ #category : #accessing }
MiBreadcrumbsBar >> shapeExtent [
	^ shapeExtent ifNil: [ self defaultShapeExtent ]
]

{ #category : #accessing }
MiBreadcrumbsBar >> shapeExtent: anObject [
	shapeExtent := anObject
]

{ #category : #accessing }
MiBreadcrumbsBar >> shapeLabel [
	^ shapeLabel ifNil: [ self defaultShapeLabel ]
]

{ #category : #accessing }
MiBreadcrumbsBar >> shapeLabel: anObject [
	shapeLabel := anObject
]

{ #category : #accessing }
MiBreadcrumbsBar >> shapePopup [
	^ shapePopup
]

{ #category : #accessing }
MiBreadcrumbsBar >> shapePopup: anObject [
	shapePopup := anObject
]
