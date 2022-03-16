"
I am a hierarchical map.
I compute the herarchical map using MiHierarchicalMapBuilder.
Handle interactions.

"
Class {
	#name : #MiHierarchicalMap,
	#superclass : #MiAbstractVisualization,
	#instVars : [
		'builder'
	],
	#category : #'MooseIDE-Dependency-HierarchicalMap'
}

{ #category : #accessing }
MiHierarchicalMap >> builder [

	^ builder
]

{ #category : #highlighting }
MiHierarchicalMap >> highlightShapes [
	

]

{ #category : #running }
MiHierarchicalMap >> run [

	super run.
	builder := MiHierarchicalMapBuilder new
		           mapModel: owner model;
		           container: self canvas;
		           yourself.
	builder build.
	self canvas
		zoomToFit;
		zoomToFit
]

{ #category : #updating }
MiHierarchicalMap >> update [

	builder ifNil: [ self run ] ifNotNil: [ builder build ]
]
