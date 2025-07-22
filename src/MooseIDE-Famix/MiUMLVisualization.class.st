Class {
	#name : 'MiUMLVisualization',
	#superclass : 'MiAbstractVisualization',
	#instVars : [
		'builder',
		'rootEntities',
		'classDescriptor'
	],
	#category : 'MooseIDE-Famix-UML',
	#package : 'MooseIDE-Famix',
	#tag : 'UML'
}

{ #category : 'initialization' }
MiUMLVisualization >> buildInCanvas: aCanvas [

	rootEntities ifNil: [ ^ self ].

	builder := RSUMLClassBuilder new
		           modelDescriptor: self classDescriptor;
		           classes: rootEntities;
		           build;
		           renderIn: aCanvas canvas;
		           yourself.

	aCanvas nodes do: [ :node |
		node addInteraction:
			((MiSelection on: [ :entity | self owner selected: entity ])
				 marginPercentage: 0.2) ].

	^ aCanvas @ RSCanvasController new noLegend
]

{ #category : 'running' }
MiUMLVisualization >> classDescriptor [

	^ classDescriptor ifNil: [
		  classDescriptor := RSUMLClassDescriptor new forFamix ]
]

{ #category : 'running' }
MiUMLVisualization >> classDescriptor: aRSUMLClassDescriptor [

	classDescriptor := aRSUMLClassDescriptor
]

{ #category : 'highlighting' }
MiUMLVisualization >> highlightShapes [

	self canvas nodes do: [ :composite | 
		composite shapes first color: (self colorFor: composite model) ]
]

{ #category : 'helpers' }
MiUMLVisualization >> noHighlightColorFor: anEntity [

	^ builder renderer boxColor
]

{ #category : 'accessing' }
MiUMLVisualization >> rootEntities: anObject [

	rootEntities := anObject
]
