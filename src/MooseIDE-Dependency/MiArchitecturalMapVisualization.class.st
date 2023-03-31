"
I am a hierarchical map.
I compute the herarchical map using MiHierarchicalMapBuilder.
Handle interactions.

"
Class {
	#name : #MiArchitecturalMapVisualization,
	#superclass : #MiAbstractVisualization,
	#instVars : [
		'builder'
	],
	#category : #'MooseIDE-Dependency-ArchitecturalMap'
}

{ #category : #accessing }
MiArchitecturalMapVisualization >> builder [

	^ builder
]

{ #category : #highlighting }
MiArchitecturalMapVisualization >> highlightShapes [
	

]

{ #category : #running }
MiArchitecturalMapVisualization >> run [

	super run.
	builder := MiArchitecturalMapBuilder new
		           mapModel: owner model;
		           container: self canvas;
		           yourself.
	self canvas @ (builder elasticBoxFor: self canvas).

	builder build
]

{ #category : #searching }
MiArchitecturalMapVisualization >> shapeFromEntity: anEntity [
	"search for the RSShape in the canvas that represent anEntity returns nil otherwise
	 each RSShape contains a HNode which contains an entity"

	^self canvas deepNodes
	detect: [ :shape | shape model ifNil: [false] ifNotNil: [:shapeModel | shapeModel rawModel = anEntity] ]
	ifNone: [ nil ]
]

{ #category : #updating }
MiArchitecturalMapVisualization >> update [

	builder ifNil: [ self run ] ifNotNil: [ builder build ]
]
