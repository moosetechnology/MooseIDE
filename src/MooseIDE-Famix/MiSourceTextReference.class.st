"
This class could possibly be merged with MiSourceTextBrowserModel
It contains the entity to display, its source code, and it can compute the list of highlights to apply on the text
"
Class {
	#name : #MiSourceTextReference,
	#superclass : #Object,
	#instVars : [
		'referenceText',
		'referenceEntity',
		'highlights'
	],
	#category : #'MooseIDE-Famix-SourceText'
}

{ #category : #accessing }
MiSourceTextReference >> addHighlight: aSourceTextHighlight [
	highlights add: aSourceTextHighlight
]

{ #category : #'highlight creation' }
MiSourceTextReference >> addIdentifierHighlightFor: aChildEntity interval: childInterval [
	^MiSourceTextIdentifierHighlight new
		referenceSource: self ;
		highlightedEntity: aChildEntity ;
		setInterval: childInterval ;
		yourself
]

{ #category : #'highlight creation' }
MiSourceTextReference >> addNullHighlightFor: aChildEntity [
	^MiSourceTextNullHighlight new
		referenceSource: self;
		highlightedEntity: aChildEntity;
		yourself
]

{ #category : #'highlight creation' }
MiSourceTextReference >> addTagHighlightFor: aChildEntity interval: childInterval [
	^MiSourceTextTagHighlight new
		referenceSource: self ;
		highlightedEntity: aChildEntity ;
		interval: childInterval ;
		yourself
]

{ #category : #api }
MiSourceTextReference >> gatherHighlights [
	self referenceEntity children do: [ :child |
		self gatherHighlightsFor: child
	]
]

{ #category : #api }
MiSourceTextReference >> gatherHighlightsFor: aChildEntity [

	self referenceEntity sourceAnchor
	ifNotNil: [ :referenceAnchor |
		(referenceAnchor textIntervalForChild: aChildEntity)
		ifNotNil: [ :childInterval | 
			self addIdentifierHighlightFor: aChildEntity interval: childInterval.
			aChildEntity children do: [ :childChild |
				self gatherHighlightsFor: childChild
			].
			aChildEntity tags do: [ :childTag |
				self addTagHighlightFor: childTag interval: childInterval.
			].
		]
	]
]

{ #category : #accessing }
MiSourceTextReference >> highlights [
	^highlights
]

{ #category : #initialization }
MiSourceTextReference >> initialize [
	super initialize.
	
	highlights := OrderedCollection new
]

{ #category : #accessing }
MiSourceTextReference >> referenceEntity [

	^ referenceEntity
]

{ #category : #accessing }
MiSourceTextReference >> referenceEntity: anObject [
	referenceEntity := anObject.
]

{ #category : #accessing }
MiSourceTextReference >> referenceText [

	^ referenceText
]

{ #category : #accessing }
MiSourceTextReference >> referenceText: anObject [
	referenceText := anObject asText
]
