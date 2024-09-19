"
I am a hierarchical map.
I compute the herarchical map using `MiArchitecturalMapBuilder`.
"
Class {
	#name : #MiArchitecturalMapVisualization,
	#superclass : #MiAbstractHierarchicalVisualization,
	#category : #'MooseIDE-Dependency-ArchitecturalMap'
}

{ #category : #running }
MiArchitecturalMapVisualization >> buildInCanvas: aCanvas [

	owner model rootNodes ifNil: [ ^ self ].

	aCanvas @ RSCanvasController new noLegend.

	builder := MiArchitecturalMapBuilder new
		           mapModel: owner model;
		           container: aCanvas;
		           build;
		           yourself
]

{ #category : #initialization }
MiArchitecturalMapVisualization >> initialize [

	super initialize.

	self script: [ :canvas | self buildInCanvas: canvas ]
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
