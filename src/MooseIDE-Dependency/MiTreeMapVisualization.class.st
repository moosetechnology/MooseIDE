Class {
	#name : #MiTreeMapVisualization,
	#superclass : #MiAbstractVisualization,
	#instVars : [
		'base',
		'childrenBlock'
	],
	#category : #'MooseIDE-Dependency-TreeMap'
}

{ #category : #helpers }
MiTreeMapVisualization >> borderFor: anEntity [
	| children |
	children := self childrenForEntity: anEntity.
	children ifEmpty: [ ^ nil ].
	^ RSBorder new
		color:
			((highlightedEntities includesAny: children)
				ifTrue: [ self highlightColor ]
				ifFalse: [ Color black ])
]

{ #category : #helpers }
MiTreeMapVisualization >> childrenForEntity: anEntity [

	"should cache #colorFor: result as it might involve intensive computing"

	"using #asHexString to have an obsolute order on Colors"

	^ (childrenBlock value: anEntity) sorted: [ :a :b | 
		  (self colorFor: a) asHexString < (self colorFor: b) asHexString ]
]

{ #category : #helpers }
MiTreeMapVisualization >> childrenOf: shape in: collection [
	collection add: shape.
	shape shapes do: [ :child | self childrenOf: child in: collection ].
	^ collection
]

{ #category : #running }
MiTreeMapVisualization >> close: shape [
	shape children copy do: #remove.
	self update.
]

{ #category : #helpers }
MiTreeMapVisualization >> colorFor: aNode [
	^ (super colorFor: aNode) alpha: 0.4
]

{ #category : #helpers }
MiTreeMapVisualization >> createPopupMorphFor: model [
	^ model asString asTextMorph
		fontName: 'Bitmap DejaVu Sans' pointSize: 11;
		backgroundColor: (Smalltalk ui theme backgroundColor alpha: 0.8);
		borderColor: Color black;
		borderWidth: 1;
		margins: 15;
		yourself
]

{ #category : #highlighting }
MiTreeMapVisualization >> highlightShapes [
	self visibleShapes
		do: [ :box | 
			box color: (self colorFor: box model).
			box border: (self borderFor: box model) ]
]

{ #category : #initialization }
MiTreeMapVisualization >> initialize [

	super initialize.
	base := RSComposite new
		draggable;
		addInteraction: (RSMorphicPopupInteraction new
			morphBuilder: [:model | self createPopupMorphFor: model ]);
		when: RSMouseLeftClick
		 	do: [ :evt | self processEvent: evt ].
	base @ (RSMenuActivable new menuDo: [ :menu :box | 
		 menu
			 add: 'Inspect'
			 target: MiInspectorBrowser
			 selector: #inspect:forBuses:
			 argumentList: { 
					 box model.
					 self owner buses } ]).
	childrenBlock := [ :entity | entity children ]
]

{ #category : #helpers }
MiTreeMapVisualization >> nodeFor: anEntity [
	| com |
	com := base copy.
	com model: anEntity.
	com border: (self borderFor: anEntity).
	com announcer: base announcer.
	com color: (self colorFor: anEntity).
	^ com
]

{ #category : #running }
MiTreeMapVisualization >> open: shape [
	| children |
	children := (self childrenForEntity: shape model) 
						collect: [ :cls | self nodeFor: cls ].
	shape addAll: children.
	self update.
]

{ #category : #running }
MiTreeMapVisualization >> processEvent: evt [
	| shape |
	shape := evt shape.
	shape children
		ifEmpty: [ self open: shape]
		ifNotEmpty: [ self close: shape ].
]

{ #category : #updating }
MiTreeMapVisualization >> relayout: shape [
	shape propertyAt: #original put: shape encompassingRectangle.

	shape shapes do: [ :s | self relayout: s ].
	RSGridLayout on: shape shapes.
	shape adjustToChildren.
	shape padding: 10.
]

{ #category : #helpers }
MiTreeMapVisualization >> rootShapes [
	^ self canvas shapes ifNotEmpty: [ :shapes | shapes first shapes ]
]

{ #category : #running }
MiTreeMapVisualization >> run [

	super run.
	self unHighlight.
	self canvas add: (RSComposite new
			 addAll:
				 (self owner model entities collect: [ :e | self nodeFor: e ]);
			 yourself).
	self update
]

{ #category : #updating }
MiTreeMapVisualization >> saveCurrent: shape [
	shape children do: [ :s | self saveCurrent: s].
	shape propertyAt: #current put: shape encompassingRectangle.
]

{ #category : #updating }
MiTreeMapVisualization >> scale: shape at: t [
	| rect1 rect2 |
	shape children do: [ :s | self scale: s at: t ].
	rect1 := shape propertyAt: #original ifAbsent: [ ^ self].
	
	rect2 := shape propertyAt: #current.
	
	shape translateTo: (rect1 center interpolateTo: rect2 center at: t).
	
	shape extent: (rect1 extent interpolateTo: rect2 extent at: t)
]

{ #category : #updating }
MiTreeMapVisualization >> update [
	| first |
	first := self canvas shapes first.
	self relayout: first.
	self saveCurrent: first.
	self canvas newAnimation
		duration: 0.5 seconds;
		onStepDo: [ :t | 
			self scale: first at: t.
			self canvas
				zoomToFit;
				signalUpdate ]
]

{ #category : #helpers }
MiTreeMapVisualization >> visibleShapes [
	^ self rootShapes
		flatCollect: [ :shape | self childrenOf: shape in: OrderedCollection new ]
]
