"
Butterfly visualization.
"
Class {
	#name : #MiButterflyMap,
	#superclass : #MiAbstractVisualization,
	#instVars : [
		'builder'
	],
	#category : #'MooseIDE-ButterflyMap'
}

{ #category : #running }
MiButterflyMap >> builder [

	^ builder
]

{ #category : #highlighting }
MiButterflyMap >> highlightShapes [
	
]

{ #category : #running }
MiButterflyMap >> run [

	super run.
	builder := MiButterflyMapBuilder new
		           mapModel: owner model;
		           container: self canvas;
		           yourself.
	builder build.
	self canvas
		zoomToFit;
		zoomToFit
]

{ #category : #running }
MiButterflyMap >> update [

	builder ifNil: [ self run ] ifNotNil: [ builder build ]
]
