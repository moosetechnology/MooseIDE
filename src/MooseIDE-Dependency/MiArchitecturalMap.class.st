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

{ #category : #searching }
MiArchitecturalMap >> shapeFromEntity: anEntity [
	"search for the RSShape in the canvas that represent anEntity returns nil otherwise
	 each RSShape contains a HNode which contains an entity"

	^self canvas deepNodes
	detect: [ :shape | shape model ifNil: [false] ifNotNil: [:shapeModel | shapeModel rawModel = anEntity] ]
	ifNone: [ nil ]
]

{ #category : #updating }
MiArchitecturalMap >> update [

	builder ifNil: [ self run ] ifNotNil: [ builder build ]
]
