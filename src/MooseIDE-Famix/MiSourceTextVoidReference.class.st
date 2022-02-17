"
A special subclass for entities without sourceCode.

"
Class {
	#name : #MiSourceTextVoidReference,
	#superclass : #MiSourceTextReference,
	#category : #'MooseIDE-Famix-SourceText'
}

{ #category : #api }
MiSourceTextVoidReference >> gatherHighlights [
	self addHighlight:
		(MiSourceTextErrorHighlight new
			referenceSource: self;
			highlightedEntity: nil;
			interval: (Interval from: 1 to: 35) ;
			yourself)
]

{ #category : #accessing }
MiSourceTextVoidReference >> referenceEntity: anEntity [
	super referenceText: ('There is no source code to show for {1}'
		format: { anEntity name })
		asText.


]

{ #category : #accessing }
MiSourceTextVoidReference >> referenceText: aText [
	"overring to do nothing. Text is set by #referenceEntity:"
]
