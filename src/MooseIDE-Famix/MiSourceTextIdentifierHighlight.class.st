"
Concrete class for highlighting an identifier in the text

"
Class {
	#name : #MiSourceTextIdentifierHighlight,
	#superclass : #MiSourceTextHighlight,
	#category : #'MooseIDE-Famix-SourceText'
}

{ #category : #formatting }
MiSourceTextIdentifierHighlight >> applyTo: aRenderer [

	aRenderer applyIdentifierHighlight: self
]

{ #category : #formatting }
MiSourceTextIdentifierHighlight >> boundingEntity [

	^highlightedEntity
]

{ #category : #formatting }
MiSourceTextIdentifierHighlight >> stringToHighlight [

	^highlightedEntity name
]
