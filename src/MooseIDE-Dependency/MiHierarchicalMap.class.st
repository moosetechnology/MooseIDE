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

{ #category : #initialization }
MiHierarchicalMap >> initialize [

	super initialize.
	builder := MiHierarchicalMapBuilder new
		           mapModel: owner model;
		           container: self canvas;
		           yourself
]

{ #category : #running }
MiHierarchicalMap >> run [

	builder build
]
