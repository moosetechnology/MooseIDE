Class {
	#name : #MiUML,
	#superclass : #MiAbstractVisualization,
	#instVars : [
		'builder',
		'rootEntities',
		'selected',
		'miUMLModelDescriptor'
	],
	#category : #'MooseIDE-Famix-UML'
}

{ #category : #highlighting }
MiUML >> highlightShapes [
	self canvas nodes
		do:
			[ :composite | composite shapes first color: (self colorFor: composite model) ]
]

{ #category : #updating }
MiUML >> initialize [
	super initialize.
	rootEntities := #()
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

{ #category : #updating }
MiUML >> rootEntities [
	^ rootEntities
]

{ #category : #updating }
MiUML >> rootEntities: aCollection [
	rootEntities := aCollection
]

{ #category : #updating }
MiUML >> run [
	super run.
	builder := RSUMLClassBuilder new.
	builder modelDescriptor: miUMLModelDescriptor.
	builder classes: self rootEntities.
	builder build.
	builder renderIn: self canvas.
	self canvas nodes
		do: [ :node | 
			node
				addInteraction:
					((MiSelection on: [ :entity | self selected: entity ])
						marginPercentage: 0.2) ].
	self canvas zoomToFit
]

{ #category : #accessing }
MiUML >> selected [
	^ selected
]

{ #category : #accessing }
MiUML >> selected: anObject [
	selected := anObject
]
