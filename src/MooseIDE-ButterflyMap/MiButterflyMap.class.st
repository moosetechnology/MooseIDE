"
Butterfly visualization.
"
Class {
	#name : #MiButterflyMap,
	#superclass : #MiAbstractVisualization,
	#instVars : [
		'builder'
	],
	#category : #'MooseIDE-ButterflyMap-Browser'
}

{ #category : #running }
MiButterflyMap >> builder [

	^ builder
]

{ #category : #highlighting }
MiButterflyMap >> highlightShapes [
	
]

{ #category : #running }
MiButterflyMap >> model [

	^ self owner model
]

{ #category : #running }
MiButterflyMap >> run [

	super run.
	builder := MiButterflyMapBuilder new
		           mapModel: owner model;
		           container: self canvas;
		           yourself.
	self canvas @ (builder elasticBoxFor: self canvas).
	builder build
]

{ #category : #running }
MiButterflyMap >> update [

	builder ifNil: [ self run ] ifNotNil: [ builder build ]
]
