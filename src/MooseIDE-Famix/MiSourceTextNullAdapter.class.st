Class {
	#name : 'MiSourceTextNullAdapter',
	#superclass : 'MiAbstractSourceTextAnchorAdapter',
	#category : 'MooseIDE-Famix-SourceText',
	#package : 'MooseIDE-Famix',
	#tag : 'SourceText'
}

{ #category : 'api' }
MiSourceTextNullAdapter >> intervalForEntity: anEntity [

	Error signal: 'No source anchor adpater found'
]
