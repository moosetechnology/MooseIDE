"
Concrete class for highlighting an identifier in the text

"
Class {
	#name : #MiSourceTextCommentHighlight,
	#superclass : #MiSourceTextHighlight,
	#category : #'MooseIDE-Famix-SourceText'
}

{ #category : #formatting }
MiSourceTextCommentHighlight >> boundingEntity [

	^highlightedEntity commentedEntity
]

{ #category : #formatting }
MiSourceTextCommentHighlight >> stringToHighlight [

	^highlightedEntity content
		replaceAll: Character cr with: Character lf
]
