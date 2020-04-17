Class {
	#name : #MiTreeMap,
	#superclass : #MiAbstractVisualization,
	#instVars : [
		'color',
		'base',
		'border',
		'rootEntities',
		'childrenBlock',
		'multiTagColorBlock',
		'noTagColorBlock'
	],
	#category : #'Midas-Dependency-TreeMap'
}

{ #category : #accessing }
MiTreeMap >> childrenBlock [
	"a block with one parameter: entity that return the list of children of this entity"
	^childrenBlock
]

{ #category : #accessing }
MiTreeMap >> childrenBlock: aBlock [
	"a block with one parameter: entity that return the list of children of this entity"
	childrenBlock := aBlock
]

{ #category : #helpers }
MiTreeMap >> childrenForEntity: anEntity [
	"should cache #colorFor: result as it might involve intensive computing"
	"using #asHexString to have an obsolute order on Colors"
	^ (self childrenBlock value: anEntity) sorted: [ :a :b | (self colorFor: a) asHexString < (self colorFor: b) asHexString ] 
]

{ #category : #running }
MiTreeMap >> close: shape [
	shape children copy do: #remove.
	self update.
]

{ #category : #helpers }
MiTreeMap >> colorFor: anEntity [
	^ self theme selectionColor
]

{ #category : #initialization }
MiTreeMap >> initialize [
	super initialize.
	canvas := RSCanvas new.
	color := RTScale category20b.

	base := RSComposite new.
	base draggable.
	base popup.
	base when: RSMouseLeftClick do: [ :evt | self processEvent: evt ].

	border := RSBorder new.
	rootEntities := #().
	childrenBlock := [ :entity | #() ]

]

{ #category : #helpers }
MiTreeMap >> nodeFor: anEntity [
	| com |
	com := base copy.
	com model: anEntity.
	(self childrenForEntity: anEntity) ifNotEmpty: [ com border: border ].
	com announcer: base announcer.
	com color: (self colorFor: anEntity) trans.
	com @ (RSMenuActivable new
		menuDo: [ :menu :box | 
			menu 
				add: 'Inspect'
				target: box model
				selector: #inspect
				argument: #() ]).
	^ com
]

{ #category : #running }
MiTreeMap >> open: shape [
	| children |
	children := (self childrenForEntity: shape model) 
						collect: [ :cls | self nodeFor: cls ].
	shape addAll: children.
	self update.
]

{ #category : #running }
MiTreeMap >> processEvent: evt [
	| shape |
	shape := evt shape.
	shape children
		ifEmpty: [ self open: shape]
		ifNotEmpty: [ self close: shape ].
]

{ #category : #updating }
MiTreeMap >> relayout: shape [
	shape attributeAt: #original put: shape encompassingRectangle.

	shape shapes do: [ :s | self relayout: s ].
	RSGridLayout on: shape shapes.
	shape adjustToChildren.
	shape padding: 10.
]

{ #category : #accessing }
MiTreeMap >> rootEntities [
	^rootEntities
]

{ #category : #accessing }
MiTreeMap >> rootEntities: aCollection [
	rootEntities := aCollection
]

{ #category : #running }
MiTreeMap >> run [
	| containerShape | 
	containerShape := RSComposite new.
	canvas add: containerShape.
	rootEntities do: [:e | containerShape add: (self nodeFor: e)].
	self update
]

{ #category : #updating }
MiTreeMap >> saveCurrent: shape [
	shape children do: [ :s | self saveCurrent: s].
	shape attributeAt: #current put: shape encompassingRectangle.
]

{ #category : #updating }
MiTreeMap >> scale: shape at: t [
	| rect1 rect2 |
	shape children do: [ :s | self scale: s at: t ].
	rect1 := shape attributeAt: #original ifAbsent: [ ^ self].
	
	rect2 := shape attributeAt: #current.
	
		
	shape translateTo: (rect1 rsCenter interpolateTo: rect2 rsCenter at: t).
	
	shape extent: (rect1 extent interpolateTo: rect2 extent at: t)
]

{ #category : #updating }
MiTreeMap >> update [
	| first |
	first := canvas shapes first.
	self relayout: first.
	self saveCurrent: first.
	canvas newAnimation
		duration: 0.5 seconds;
		onStepDo: [ :t | 
			self scale: first at: t.
			canvas
				zoomToFit;
				signalUpdate ]
]
