"
Concrete class for highlighting an identifier in the text

"
Class {
	#name : #MiSourceTextIdentifierHighlight,
	#superclass : #MiSourceTextHighlight,
	#category : #'MooseIDE-Famix-SourceText'
}

{ #category : #formatting }
MiSourceTextIdentifierHighlight >> adaptSourceAnchorWith: aSourceAnchorAdapter [

	(aSourceAnchorAdapter intervalForEntity: highlightedEntity)
		ifNotNil: [ :entityInterval || entityNameStart |
			entityNameStart := aSourceAnchorAdapter displayedText
				findString: highlightedEntity name
				startingAt: entityInterval first.

			highlightInterval := Interval
				from: entityNameStart
				to: (entityNameStart + highlightedEntity name size - 1) 
		].
]

{ #category : #formatting }
MiSourceTextIdentifierHighlight >> applyTo: aRenderer [

	self adaptSourceAnchorWith: aRenderer sourceAnchorAdapter.

	highlightInterval ifNotNil: [ aRenderer applyIdentifierHighlight: self ]
]
