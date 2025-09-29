Class {
	#name : #MiSourceTextNullAdapter,
	#superclass : #MiAbstractSourceTextAnchorAdapter,
	#category : #'MooseIDE-Famix-SourceText'
}

{ #category : #api }
MiSourceTextNullAdapter >> intervalForEntity: anEntity [

	Error signal: 'No source anchor adpater found'
]
