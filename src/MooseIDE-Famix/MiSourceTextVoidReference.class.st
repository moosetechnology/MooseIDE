Class {
	#name : #MiSourceTextVoidReference,
	#superclass : #MiSourceTextReference,
	#category : #'MooseIDE-Famix-SourceText'
}

{ #category : #api }
MiSourceTextVoidReference >> gatherHighlights [
	self addHighlight:
		(MiSourceTextRawHighlight new
			referenceSource: self;
			highlightedEntity: nil;
			attribute: TextColor red ;
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
