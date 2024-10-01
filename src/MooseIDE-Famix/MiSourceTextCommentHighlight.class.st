"
Concrete class for highlighting an identifier in the text

"
Class {
	#name : #MiSourceTextCommentHighlight,
	#superclass : #MiSourceTextHighlight,
	#category : #'MooseIDE-Famix-SourceText'
}

{ #category : #formatting }
MiSourceTextCommentHighlight >> applyTo: aRenderer [
	aRenderer applyCommentHighlight: self
]
