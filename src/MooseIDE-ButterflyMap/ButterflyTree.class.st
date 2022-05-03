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

{ #category : #adding }
ButterflyTree >> removeLevel [

	leftTree removeLevel.
	rightTree removeLevel
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
