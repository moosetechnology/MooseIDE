Class {
	#name : 'MiLVBoxStyle',
	#superclass : 'Object',
	#instVars : [
		'border',
		'background'
	],
	#category : 'MooseIDE-LayerVisualization-Model',
	#package : 'MooseIDE-LayerVisualization',
	#tag : 'Model'
}

{ #category : 'accessing' }
MiLVBoxStyle >> background [

	^ background
]

{ #category : 'accessing' }
MiLVBoxStyle >> background: anObject [

	background := anObject
]

{ #category : 'accessing' }
MiLVBoxStyle >> border [

	^ border
]

{ #category : 'accessing' }
MiLVBoxStyle >> border: anObject [

	border := anObject
]

{ #category : 'initialization' }
MiLVBoxStyle >> initialize [

	super initialize. 
	border := #line.
	background := Color transparent
]
