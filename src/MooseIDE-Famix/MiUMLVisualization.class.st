Class {
	#name : #MiUMLVisualization,
	#superclass : #MiAbstractVisualization,
	#instVars : [
		'builder',
		'rootEntities',
		'classDescriptor'
	],
	#category : #'MooseIDE-Famix-UML'
}

{ #category : #running }
MiUMLVisualization >> classDescriptor [

	^ classDescriptor ifNil: [
		  classDescriptor := RSUMLClassDescriptor new forFamix ]
]

{ #category : #running }
MiUMLVisualization >> classDescriptor: aRSUMLClassDescriptor [

	classDescriptor := aRSUMLClassDescriptor
]

{ #category : #highlighting }
MiUMLVisualization >> highlightShapes [

	self canvas nodes do: [ :composite | 
		composite shapes first color: (self colorFor: composite model) ]
]

{ #category : #initialization }
MiUMLVisualization >> initialize [

	super initialize.
	rootEntities := #(  )
]

{ #category : #helpers }
MiUMLVisualization >> noHighlightColorFor: anEntity [

	^ builder renderer boxColor
]

{ #category : #accessing }
MiUMLVisualization >> rootEntities: anObject [

	rootEntities := anObject
]

{ #category : #running }
MiUMLVisualization >> run [

	super run.
	builder := RSUMLClassBuilder new
		           modelDescriptor: self classDescriptor;
		           classes: rootEntities;
		           build;
		           renderIn: self canvas;
		           yourself.

	self canvas nodes do: [ :node |
		node addInteraction:
			((MiSelection on: [ :entity | self owner selected: entity ])
				 marginPercentage: 0.2) ].

	self canvas zoomToFit
]
