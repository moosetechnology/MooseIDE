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

{ #category : #accessing }
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
		source children do: [ :child | q addFirst: child ].
		j := j + source children size.
		i <= 0 ifTrue: [ "Here we reached an new level"
			i := j.
			j := 0.
			depth := depth + 1 ] ].
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

{ #category : #adding }
ButterflyNode >> generateChildrenFor: anEntity [

	anEntity = entity
		ifTrue: [ self generateChildren ]
		ifFalse: [ children copy do: [ :c | c generateChildrenFor: anEntity ] ]
]

{ #category : #initialization }
ButterflyNode >> initialize [ 

	super initialize.
	children := OrderedCollection new.
	childrenBlock := [ :e | {  } ]
]

{ #category : #accessing }
ButterflyNode >> layers [

	"Return all levels of this tree, exept current node. Return a collection of collections."

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

{ #category : #accessing }
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
	parent remove: self.
	entity model remove.
	entity connectedLines copy do: #remove.
	entity remove.
	children copy do: #remove
]

{ #category : #removing }
ButterflyNode >> remove: aBNode [

	children remove: aBNode
]

{ #category : #removing }
ButterflyNode >> removeChildren [

	children copy do: #remove
]

{ #category : #removing }
ButterflyNode >> removeChildrenFor: anEntity [

	anEntity = entity
		ifTrue: [ self removeChildren ]
		ifFalse: [ children copy do: [ :c | c removeChildrenFor: anEntity ] ]
]

{ #category : #removing }
ButterflyNode >> removeLevel [

	self removeLevel: self root depth
]

{ #category : #removing }
ButterflyNode >> removeLevel: anInteger [

	self level = anInteger
		ifTrue: [ self remove ]
		ifFalse: [ children copy do: [ :c | c removeLevel: anInteger ] ]
]

{ #category : #removing }
ButterflyNode >> removeSubNode: anEntity [

	anEntity = entity
		ifTrue: [ self remove ]
		ifFalse: [ children copy do: [ :c | c removeSubNode: anEntity ] ]
]

{ #category : #accessing }
ButterflyNode >> root [

	parent ifNil: [ ^ self ].
	^ parent root
]
