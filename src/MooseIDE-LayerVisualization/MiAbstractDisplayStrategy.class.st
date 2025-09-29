Class {
	#name : #MiAbstractDisplayStrategy,
	#superclass : #Object,
	#instVars : [
		'visualizationModel'
	],
	#category : #'MooseIDE-LayerVisualization-Strategy'
}

{ #category : #filtering }
MiAbstractDisplayStrategy >> addDto: dto in: dict atKey: aSymbol [

	^ dict at: aSymbol ifPresent: [ :coll | coll add: dto ]
]

{ #category : #accessing }
MiAbstractDisplayStrategy >> visualizationModel: anObject [

	visualizationModel := anObject
]
