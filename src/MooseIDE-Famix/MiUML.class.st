Class {
	#name : #MiUML,
	#superclass : #MiAbstractVisualization,
	#instVars : [
		'builder',
		'rootEntities',
		'miUMLModelDescriptor',
		'selectionChange'
	],
	#category : #'MooseIDE-Famix-UML'
}

{ #category : #highlighting }
MiUML >> highlightShapes [

	self canvas nodes do: [ :composite | 
		composite shapes first color: (self colorFor: composite model) ]
]

{ #category : #initialization }
MiUML >> initialize [

	super initialize.
	rootEntities := #(  )
]

{ #category : #accessing }
MiUML >> miUMLModelDescriptor [

	^ miUMLModelDescriptor ifNil: [ RSUMLClassDescriptor new forFamix ]
]

{ #category : #accessing }
MiUML >> miUMLModelDescriptor: anObject [

	miUMLModelDescriptor := anObject
]

{ #category : #helpers }
MiUML >> noHighlightColorFor: anEntity [

	^ builder renderer boxColor
]

{ #category : #accessing }
MiUML >> rootEntities [

	^ rootEntities
]

{ #category : #accessing }
MiUML >> rootEntities: anObject [

	rootEntities := anObject
]

{ #category : #running }
MiUML >> run [

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
