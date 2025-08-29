"
Concrete class for highlighting an identifier in the text

"
Class {
	#name : 'MiSourceTextIdentifierHighlight',
	#superclass : 'MiSourceTextHighlight',
	#category : 'MooseIDE-Famix-SourceText',
	#package : 'MooseIDE-Famix',
	#tag : 'SourceText'
}

{ #category : 'formatting' }
MiSourceTextIdentifierHighlight >> applyTo: aRenderer [

	aRenderer applyIdentifierHighlight: self
]
