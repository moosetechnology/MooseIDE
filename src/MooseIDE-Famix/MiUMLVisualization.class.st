Class {
	#name : #MiUMLVisualization,
	#superclass : #MiAbstractVisualization,
	#instVars : [
		'builder',
		'rootEntities',
		'miUMLModelDescriptor'
	],
	#category : #'MooseIDE-Famix-UML'
}

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

{ #category : #accessing }
MiUMLVisualization >> miUMLModelDescriptor [

	^ miUMLModelDescriptor ifNil: [ RSUMLClassDescriptor new forFamix ]
]

{ #category : #accessing }
MiUMLVisualization >> miUMLModelDescriptor: anObject [

	miUMLModelDescriptor := anObject
]

{ #category : #helpers }
MiUMLVisualization >> noHighlightColorFor: anEntity [

	^ builder renderer boxColor
]

{ #category : #accessing }
MiUMLVisualization >> rootEntities [

	^ rootEntities
]

{ #category : #accessing }
MiUMLVisualization >> rootEntities: anObject [

	rootEntities := anObject
]

{ #category : #running }
MiUMLVisualization >> run [

	super run.
	builder := RSUMLClassBuilder new.
	builder modelDescriptor: self miUMLModelDescriptor.
	builder classes: self rootEntities.
	builder build.
	builder renderIn: self canvas.
	self canvas nodes do: [ :node | 
		node addInteraction:
			((MiSelection on: [ :entity | self owner selected: entity ]) 
				 marginPercentage: 0.2) ].
	self canvas zoomToFit
]
