Class {
	#name : #MiSourceTextRawHighlight,
	#superclass : #MiSourceTextHighlight,
	#instVars : [
		'attribute'
	],
	#category : #'MooseIDE-Famix-SourceText'
}

{ #category : #formatting }
MiSourceTextRawHighlight >> apply [
	self referenceText 
		addAttribute: attribute from: self from to: self to.

]

{ #category : #accessing }
MiSourceTextRawHighlight >> attribute: aTextAttribute [
	attribute := aTextAttribute
]
