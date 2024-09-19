"
Butterfly visualization.
"
Class {
	#name : #MiButterflyMapVisualization,
	#superclass : #MiAbstractHierarchicalVisualization,
	#category : #'MooseIDE-ButterflyMap-Browser'
}

{ #category : #running }
MiButterflyMapVisualization >> buildInCanvas: aCanvas [

	owner model currentEntity ifNil: [ ^ self ].

	builder := MiButterflyMapBuilder new
		           mapModel: owner model;
		           container: aCanvas;
		           yourself.
	builder build
]

{ #category : #initialization }
MiButterflyMapVisualization >> initialize [

	super initialize.

	self script: [ :canvas | self buildInCanvas: canvas ]
]

{ #category : #running }
MiButterflyMapVisualization >> update [

	self refresh
]
