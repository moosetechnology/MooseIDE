Class {
	#name : #MiSourceTextIdentifierHighlight,
	#superclass : #MiSourceTextHighlight,
	#category : #'MooseIDE-Famix-SourceText'
}

{ #category : #formatting }
MiSourceTextIdentifierHighlight >> applyTo: aRenderer [
	aRenderer applyIdentifierHighlight: self
]

{ #category : #api }
MiSourceTextIdentifierHighlight >> setInterval: anInterval [
	"sets the interval to the 1st line containing the entity identifier"
	| myStart |
	myStart := self referenceText
		findString: self highlightedEntity name
		startingAt: anInterval first.
.
	self interval:
		(Interval
			from: myStart
			to: (myStart + self highlightedEntity name size - 1))

]
