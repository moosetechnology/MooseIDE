Class {
	#name : #MiSourceTextTagHighlight,
	#superclass : #MiSourceTextHighlight,
	#category : #'MooseIDE-Famix-SourceText'
}

{ #category : #formatting }
MiSourceTextTagHighlight >> toRoassal [
	^RSTagEmphasisAttribute new
		from: self from ;
		to: self to ;
		color: self highlightedEntity color ; 
		on: RSMouseClick do: [ :event | uiModel selected: self highlightedEntity ] ;
		yourself
]
