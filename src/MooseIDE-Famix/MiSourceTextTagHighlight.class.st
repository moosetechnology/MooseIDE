"
Concrete class for highlighting a tagged entity in the text.

It does not know the tag, the #highlightedEntity must know it
"
Class {
	#name : 'MiSourceTextTagHighlight',
	#superclass : 'MiSourceTextHighlight',
	#instVars : [
		'color'
	],
	#category : 'MooseIDE-Famix-SourceText',
	#package : 'MooseIDE-Famix',
	#tag : 'SourceText'
}

{ #category : 'formatting' }
MiSourceTextTagHighlight >> applyTo: aRenderer [
	aRenderer applyTagHighlight: self
]

{ #category : 'accessing' }
MiSourceTextTagHighlight >> color [

	^ color
]

{ #category : 'accessing' }
MiSourceTextTagHighlight >> color: aFamixTag [ 

	color := aFamixTag
]
