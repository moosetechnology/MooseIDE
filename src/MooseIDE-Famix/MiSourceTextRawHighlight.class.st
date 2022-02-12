Class {
	#name : #MiSourceTextRawHighlight,
	#superclass : #MiSourceTextHighlight,
	#instVars : [
		'attribute'
	],
	#category : #'MooseIDE-Famix-SourceText'
}

{ #category : #accessing }
MiSourceTextRawHighlight >> attribute: aTextAttribute [
	attribute := aTextAttribute
]

{ #category : #formatting }
MiSourceTextRawHighlight >> toRoassal [
	self referenceText 
		addAttribute: attribute from: self from to: self to.

]
