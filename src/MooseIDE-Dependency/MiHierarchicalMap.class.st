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
