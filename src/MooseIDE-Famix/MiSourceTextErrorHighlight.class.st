"
Concrete class for highlighting an error in the text

e.g. it could be rendered as a red text
"
Class {
	#name : #MiSourceTextErrorHighlight,
	#superclass : #MiSourceTextHighlight,
	#instVars : [
		'attribute'
	],
	#category : #'MooseIDE-Famix-SourceText'
}

{ #category : #formatting }
MiSourceTextErrorHighlight >> adaptSourceAnchorWith: aSourceAnchorAdapter [

	"Nothing to do the interval should already be defined"
]

{ #category : #formatting }
MiSourceTextErrorHighlight >> applyTo: aRenderer [

	aRenderer applyErrorHighlight: self
]
