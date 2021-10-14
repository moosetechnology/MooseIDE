Class {
	#name : #MiUML,
	#superclass : #MiAbstractVisualization,
	#instVars : [
		'builder',
		'miUMLModelDescriptor'
	],
	#category : #'MooseIDE-Famix-UML'
}

{ #category : #highlighting }
MiUML >> highlightShapes [

	self canvas nodes do: [ :composite | 
		composite shapes first color: (self colorFor: composite model) ]
]

{ #category : #helpers }
MiUML >> noHighlightColorFor: anEntity [

	^ builder renderer boxColor
]

{ #category : #running }
MiUML >> run [

	super run.
	builder := RSUMLClassBuilder new.
	builder modelDescriptor: RSUMLClassDescriptor new forFamix.
	builder classes: self owner model entities.
	builder build.
	builder renderIn: self canvas.
	self canvas nodes do: [ :node | 
		node addInteraction:
			((MiSelection on: [ :entity | self owner model selected: entity ]) 
				 marginPercentage: 0.2) ].
	self canvas zoomToFit
]
