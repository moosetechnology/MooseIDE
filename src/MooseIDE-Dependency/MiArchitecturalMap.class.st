"
I am a hierarchical map.
I compute the herarchical map using MiHierarchicalMapBuilder.
Handle interactions.

"
Class {
	#name : #MiArchitecturalMap,
	#superclass : #MiAbstractVisualization,
	#instVars : [
		'builder'
	],
	#category : #'MooseIDE-Dependency-ArchitecturalMap'
}

{ #category : #accessing }
MiArchitecturalMap >> builder [

	^ builder
]

{ #category : #highlighting }
MiArchitecturalMap >> highlightShapes [
	

]

{ #category : #running }
MiArchitecturalMap >> run [

	super run.
	builder := MiArchitecturalMapBuilder new
		           mapModel: owner model;
		           container: self canvas;
		           yourself.
	self canvas @ (builder elasticBoxFor: self canvas).

	builder build
]

{ #category : #updating }
MiArchitecturalMap >> update [

	builder ifNil: [ self run ] ifNotNil: [ builder build ]
]
