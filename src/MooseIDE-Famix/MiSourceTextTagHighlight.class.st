"
Concrete class for highlighting a tagged entity in the text.

It does not know the tag, the #highlightedEntity must know it
"
Class {
	#name : #MiSourceTextTagHighlight,
	#superclass : #MiSourceTextHighlight,
	#instVars : [
		'tag'
	],
	#category : #'MooseIDE-Famix-SourceText'
}

{ #category : #formatting }
MiSourceTextTagHighlight >> applyTo: aRenderer [
	aRenderer applyTagHighlight: self
]

{ #category : #accessing }
MiSourceTextTagHighlight >> tag [

	^ tag
]

{ #category : #accessing }
MiSourceTextTagHighlight >> tag: aFamixTag [ 

	tag := aFamixTag
]
