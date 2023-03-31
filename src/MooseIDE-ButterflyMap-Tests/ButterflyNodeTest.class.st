Class {
	#name : #ButterflyNodeTest,
	#superclass : #TestCase,
	#instVars : [
		'randomGenerator',
		'butterflyNode'
	],
	#category : #'MooseIDE-ButterflyMap-Tests-Model'
}

{ #category : #running }
ButterflyNodeTest >> randomNumber [

	^ (randomGenerator next * 10) asInteger + 1
]

{ #category : #running }
ButterflyNodeTest >> setUp [

	super setUp.
	randomGenerator := Random seed: 4815162342.
	butterflyNode := ButterflyNode new
		             entity: Mock new;
		             yourself.
	butterflyNode childrenBlock: [ :e | 
		| children |
		children := OrderedCollection new.
		self randomNumber timesRepeat: [ children add: Mock new ].
		children ]
]

{ #category : #tests }
ButterflyNodeTest >> testAddChild [

	| aBNode |
	aBNode := ButterflyNode new
		          entity: Mock new;
		          yourself.
	butterflyNode add: aBNode.
	self assert: (butterflyNode children includes: aBNode).
	self assert: aBNode parent equals: butterflyNode
]

{ #category : #tests }
ButterflyNodeTest >> testAddLevel [

	self assert: butterflyNode depth equals: 0.
	butterflyNode addLevel.
	self assert: butterflyNode depth equals: 1.
	self assert: butterflyNode children isNotEmpty
]

{ #category : #tests }
ButterflyNodeTest >> testLayers [

	| numberOfLevels layers |
	numberOfLevels := 5.
	numberOfLevels timesRepeat: [ butterflyNode addLevel ].
	layers := butterflyNode layers.
	self assert: butterflyNode depth equals: numberOfLevels.
	self assert: layers size equals: numberOfLevels.
	
]

{ #category : #tests }
ButterflyNodeTest >> testRemoveChild [

	| aBNode |
	aBNode := ButterflyNode new
		          entity: Mock new;
		          yourself.
	butterflyNode add: aBNode.
	butterflyNode remove: aBNode.
	self deny: (butterflyNode children includes: aBNode).
	
]

{ #category : #tests }
ButterflyNodeTest >> testRemoveLevel [

	butterflyNode addLevel.
	self assert: butterflyNode depth equals: 1.
	butterflyNode removeLevel.
	self assert: butterflyNode depth equals: 0
]

{ #category : #tests }
ButterflyNodeTest >> testRemoveNode [

	| aBNode |
	aBNode := ButterflyNode new
		          entity: Mock new;
		          yourself.
	butterflyNode add: aBNode.
	aBNode remove.
	aBNode entity should receive remove.
	self assert: butterflyNode children size equals: 0
]
