Class {
	#name : #MiHierarchicalVisualizationTest,
	#superclass : #TestCase,
	#instVars : [
		'viz'
	],
	#category : #'MooseIDE-Tests-Browsers'
}

{ #category : #tests }
MiHierarchicalVisualizationTest >> setUp [
	super setUp.
	viz := MiHierarchicalVisualization new.
	viz childrenBlock: [ :any | #() ]

]

{ #category : #tests }
MiHierarchicalVisualizationTest >> testDefaultNodeIconForClass [

	self assert: (viz nodeFor: FamixJavaClass new) iconName equals: #famixClass
]

{ #category : #tests }
MiHierarchicalVisualizationTest >> testDefaultNodeIconForUnknown [

	self assert: (viz nodeFor: FamixJavaComment new) iconName equals: nil
]

{ #category : #tests }
MiHierarchicalVisualizationTest >> testNodeName [
	| entity |
	entity := FamixJavaClass new
		name: #blah ;
		yourself.
	self assert: (viz nodeFor: entity) name equals: #blah
]
