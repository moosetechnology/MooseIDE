"
I am a hierarchical map.
I compute the herarchical map using `MiArchitecturalMapBuilder`.
"
Class {
	#name : 'MiArchitecturalMapVisualization',
	#superclass : 'MiAbstractHierarchicalVisualization',
	#category : 'MooseIDE-ArchitecturalMap-browser',
	#package : 'MooseIDE-ArchitecturalMap',
	#tag : 'browser'
}

{ #category : 'running' }
MiArchitecturalMapVisualization >> buildInCanvas: aCanvas [

	owner specModel rootNodes ifNil: [ ^ self ].

	aCanvas @ RSCanvasController new noLegend.

	builder := MiArchitecturalMapBuilder new
		           mapModel: owner specModel;
		           container: aCanvas;
		           build;
		           yourself
]

{ #category : 'interactions' }
MiArchitecturalMapVisualization >> hideAllLinks: aShape [ 

	HHideAllLinksMenuItem new
		context: aShape ;
		visualization: builder ;
		execute
]

{ #category : 'interactions' }
MiArchitecturalMapVisualization >> selectRelatedTo: anEntity [ 

	builder selectRelatedTo: anEntity 

]

{ #category : 'searching' }
MiArchitecturalMapVisualization >> shapeFromEntity: anEntity [
	"search for the RSShape in the canvas that represent anEntity returns nil otherwise
	 each RSShape contains a HNode which contains an entity"

	^ self canvas deepNodes
		  detect: [ :shape |
			  shape model
				  ifNil: [ false ]
				  ifNotNil: [ :shapeModel | shapeModel rawModel = anEntity ] ]
		  ifNone: [ nil ]
]

{ #category : 'interactions' }
MiArchitecturalMapVisualization >> showAllLinks: aShape [ 

	HShowAllLinksMenuItem new
		context: aShape ;
		visualization: builder ;
		execute
]
