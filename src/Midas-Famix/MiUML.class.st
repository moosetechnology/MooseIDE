Class {
	#name : #MiUML,
	#superclass : #MiAbstractVisualization,
	#instVars : [
		'diagram',
		'builder',
		'rootEntities'
	],
	#category : #'Midas-Famix-UML'
}

{ #category : #updating }
MiUML >> initialize [
	super initialize.
	
	rootEntities := #().
]

{ #category : #updating }
MiUML >> rootEntities [
	^rootEntities
]

{ #category : #updating }
MiUML >> rootEntities: aCollection [
	rootEntities := aCollection
]

{ #category : #updating }
MiUML >> run [
	super run.
	builder := RSUMLClassBuilder new.
	builder modelDescriptor forFamix.
	builder classes: self rootEntities.
	builder build.
	builder renderIn: self canvas.
	self canvas zoomToFit
]
