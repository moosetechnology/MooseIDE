Class {
	#name : 'MiSourceTextKeywordHighlight',
	#superclass : 'MiSourceTextHighlight',
	#category : 'MooseIDE-Famix-SourceText',
	#package : 'MooseIDE-Famix',
	#tag : 'SourceText'
}

{ #category : 'formatting' }
MiSourceTextKeywordHighlight >> adaptSourceAnchorWith: aSourceAnchorAdapter [
	"Nothing to do the interval should already be defined"

	^highlightInterval
]

{ #category : 'formatting' }
MiSourceTextKeywordHighlight >> applyTo: aRenderer [

	aRenderer applyKeywordHighlight: self
]
