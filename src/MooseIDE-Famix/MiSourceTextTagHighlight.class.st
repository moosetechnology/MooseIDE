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
		yourself
]
