Class {
	#name : #MiLVAbstractElement,
	#superclass : #MiLVAbstractNode,
	#instVars : [
		'model'
	],
	#category : #'MooseIDE-LayerVisualization-Model'
}

{ #category : #accessing }
MiLVAbstractElement >> model [

	^ model
]

{ #category : #accessing }
MiLVAbstractElement >> model: anObject [

	model := anObject
]

{ #category : #accessing }
MiLVAbstractElement >> name [

	^ String streamContents: [ :s | model displayStringOn: s ]
]
