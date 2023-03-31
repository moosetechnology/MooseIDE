Class {
	#name : #ButterflyTree,
	#superclass : #Object,
	#instVars : [
		'root',
		'lBlock',
		'rBlock',
		'leftTree',
		'rightTree'
	],
	#category : #'MooseIDE-ButterflyMap-Model'
}

{ #category : #adding }
ButterflyTree >> addLevel [

	(root isNil or: [ lBlock isNil or: [ rBlock isNil ] ]) ifTrue: [ 
		^ self ].
	leftTree addLevel.
	rightTree addLevel
]

{ #category : #adding }
ButterflyTree >> generateChildrenFor: aShape [

	leftTree generateChildrenFor: aShape.
	rightTree generateChildrenFor: aShape
]

{ #category : #accessing }
ButterflyTree >> lBlock [

	^ lBlock
]

{ #category : #accessing }
ButterflyTree >> lBlock: anObject [

	lBlock := anObject.
	leftTree childrenBlock: lBlock
]

{ #category : #accessing }
ButterflyTree >> leftTree [

	^ leftTree
]

{ #category : #accessing }
ButterflyTree >> rBlock [

	^ rBlock
]

{ #category : #accessing }
ButterflyTree >> rBlock: anObject [

	rBlock := anObject.
	rightTree childrenBlock: rBlock
]

{ #category : #removing }
ButterflyTree >> remove: anEntity [

	leftTree removeSubNode: anEntity.
	rightTree removeSubNode: anEntity 
]

{ #category : #removing }
ButterflyTree >> removeChildrenFor: aShape [

	leftTree removeChildrenFor: aShape.
	rightTree removeChildrenFor: aShape
]

{ #category : #removing }
ButterflyTree >> removeLevel [

	| maxLevel |
	maxLevel := leftTree depth max: rightTree depth.
	maxLevel <= 1 ifTrue: [ ^ self ].
	leftTree depth < maxLevel ifFalse: [ leftTree removeLevel: maxLevel ].
	rightTree depth < maxLevel ifFalse: [ 
		rightTree removeLevel: maxLevel ]
]

{ #category : #accessing }
ButterflyTree >> rightTree [

	^ rightTree
]

{ #category : #accessing }
ButterflyTree >> root [

	^ root
]

{ #category : #accessing }
ButterflyTree >> root: anObject [

	root := ButterflyNode new
		        entity: anObject;
		        yourself.
	(rightTree := ButterflyNode new)
		entity: root entity;
		childrenBlock: rBlock.
	(leftTree := ButterflyNode new)
		entity: root entity;
		childrenBlock: lBlock.
]
