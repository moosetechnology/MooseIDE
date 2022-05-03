Class {
	#name : #ButterflyNode,
	#superclass : #Object,
	#instVars : [
		'children',
		'parent',
		'entity',
		'childrenBlock'
	],
	#category : #'MooseIDE-ButterflyMap-Model'
}

{ #category : #adding }
ButterflyNode >> add: aBNode [

	children add: aBNode.
	aBNode parent: self.
	aBNode childrenBlock: childrenBlock
]

{ #category : #adding }
ButterflyNode >> addLevel [

	children do: #addLevel.
	self generateChildren
]

{ #category : #accessing }
ButterflyNode >> children [

	^ children
]

{ #category : #accessing }
ButterflyNode >> children: anObject [

	children := anObject
]

{ #category : #accessing }
ButterflyNode >> childrenBlock [

	^ childrenBlock
]

{ #category : #accessing }
ButterflyNode >> childrenBlock: anObject [

	childrenBlock := anObject
]

{ #category : #adding }
ButterflyNode >> depth [

	| q source depth i j |
	depth := 0.
	q := LinkedList new.
	children do: [ :child | q addFirst: child ].
	i := children size.
	j := 0.

	[ q isNotEmpty ] whileTrue: [ 
		source := q removeLast.
		i := i - 1.
		i <= 0 ifTrue: [ "Here we reached an new level"
			i := j.
			j := 0.
			depth := depth + 1 ].
		source children do: [ :child | q addFirst: child ].
		j := j + source children size ].
	^ depth
]

{ #category : #accessing }
ButterflyNode >> entity [

	^ entity
]

{ #category : #accessing }
ButterflyNode >> entity: anObject [

	entity := anObject
]

{ #category : #adding }
ButterflyNode >> generateChildren [

	children ifNotEmpty: [ ^ children ].
	(childrenBlock value: entity) do: [ :e | 
		self add: (self class new
				 entity: e;
				 yourself) ].
	^ children
]

{ #category : #initialization }
ButterflyNode >> initialize [ 

	super initialize.
	children := OrderedCollection new.
	childrenBlock := [ :e | {  } ]
]

{ #category : #accessing }
ButterflyNode >> layers [

	| q source layers i j layer |
	layers := OrderedCollection new.
	layer := RSGroup new.
	q := LinkedList new.
	children do: [ :child | q addFirst: child ].
	i := children size.
	j := 0.

	[ q isNotEmpty ] whileTrue: [ 
		source := q removeLast.
		layer add: source entity.
		i := i - 1.

		source children do: [ :child | q addFirst: child ].
		j := j + source children size.
		i <= 0 ifTrue: [ "Here we reached an new level"
			i := j.
			j := 0.
			layers add: layer.
			layer := RSGroup new ] ].

	^ layers
]

{ #category : #adding }
ButterflyNode >> level [

	parent ifNil: [ ^ 0 ].
	^ parent level + 1
]

{ #category : #accessing }
ButterflyNode >> parent [

	^ parent
]

{ #category : #accessing }
ButterflyNode >> parent: anObject [

	parent := anObject
]

{ #category : #removing }
ButterflyNode >> remove [

	parent ifNil: [ ^ self ].
	parent remove: self
]

{ #category : #removing }
ButterflyNode >> remove: aBNode [

	children remove: aBNode
]

{ #category : #adding }
ButterflyNode >> removeLevel [

	(self level = self root depth) ifTrue: [ self remove.  ].
	children do: #removeLevel
]

{ #category : #adding }
ButterflyNode >> root [

	parent ifNil: [ ^ self ].
	^ parent root
]
