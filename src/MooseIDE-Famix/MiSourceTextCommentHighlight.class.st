"
Concrete class for highlighting an identifier in the text

"
Class {
	#name : #MiSourceTextCommentHighlight,
	#superclass : #MiSourceTextHighlight,
	#category : #'MooseIDE-Famix-SourceText'
}

{ #category : #formatting }
MiSourceTextCommentHighlight >> adaptSourceAnchorWith: aSourceAnchorAdapter [

	"(aSourceAnchorAdapter intervalForEntity: highlightedEntity)
		ifNotNil: [ :entityInterval |
			
		]"
]

{ #category : #formatting }
MiSourceTextCommentHighlight >> applyTo: aRenderer [

	self adaptSourceAnchorWith: aRenderer sourceAnchorAdapter.
	aRenderer applyCommentHighlight: self
]
