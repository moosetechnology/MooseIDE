"
Butterfly visualization.
"
Class {
	#name : #MiButterflyMapVisualization,
	#superclass : #MiAbstractVisualization,
	#instVars : [
		'builder'
	],
	#category : #'MooseIDE-ButterflyMap-Browser'
}

{ #category : #running }
MiButterflyMapVisualization >> builder [

	^ builder
]

{ #category : #highlighting }
MiButterflyMapVisualization >> highlightShapes [
	
]

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
