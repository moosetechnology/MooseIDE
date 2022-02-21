Class {
	#name : #MiSourceTextTagHighlight,
	#superclass : #MiSourceTextHighlight,
	#category : #'MooseIDE-Famix-SourceText'
}

{ #category : #formatting }
MiSourceTextTagHighlight >> apply [
	self referenceText
		addAttribute: (TextBackgroundColor color: (self highlightedEntity color)) from: self from to: self to
]
