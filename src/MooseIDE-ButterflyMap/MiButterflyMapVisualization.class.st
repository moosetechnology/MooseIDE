"
Butterfly visualization.
"
Class {
	#name : #MiButterflyMapVisualization,
	#superclass : #MiAbstractHierarchicalVisualization,
	#category : #'MooseIDE-ButterflyMap-Browser'
}

{ #category : #running }
MiButterflyMapVisualization >> model [

	^ self owner model
]

{ #category : #running }
MiButterflyMapVisualization >> run [

	super run.
	builder := MiButterflyMapBuilder new
		           mapModel: owner model;
		           container: self canvas;
		           yourself.
	builder build
]

{ #category : #running }
MiButterflyMapVisualization >> update [

	builder ifNil: [ self run ] ifNotNil: [ builder build ]
]
