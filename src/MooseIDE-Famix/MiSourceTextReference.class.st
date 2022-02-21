Class {
	#name : #MiSourceTextReference,
	#superclass : #Object,
	#instVars : [
		'referenceText',
		'referenceEntity',
		'textBrowser',
		'highlights'
	],
	#category : #'MooseIDE-Famix-SourceText'
}

{ #category : #accessing }
MiSourceTextReference >> addHighlight: aSourceTextHighlight [
	highlights add: aSourceTextHighlight
]

{ #category : #api }
MiSourceTextReference >> applyHighlights [
	highlights do: #apply
]

{ #category : #'highlight creation' }
MiSourceTextReference >> createIdentifierHighlightFor: aChildEntity interval: childInterval [
	^MiSourceTextIdentifierHighlight new
		referenceSource: self ;
		highlightedEntity: aChildEntity ;
		setInterval: childInterval ;
		yourself
]

{ #category : #'highlight creation' }
MiSourceTextReference >> createNullHighlightFor: aChildEntity [

	^ MiSourceTextNullHighlight new
		  referenceSource: self;
		  highlightedEntity: aChildEntity;
		  yourself
]

{ #category : #'highlight creation' }
MiSourceTextReference >> createTagHighlightFor: aChildEntity interval: childInterval [
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
		(referenceAnchor childInterval: aChildEntity)
		ifNotNil: [ :childInterval | 
			self addHighlight:
				(self createIdentifierHighlightFor: aChildEntity interval: childInterval).
			aChildEntity children do: [ :childChild |
				self gatherHighlightsFor: childChild
			].
			aChildEntity tags do: [ :childTag |
			self addHighlight:
				(self createTagHighlightFor: childTag interval: childInterval).
			].
		]
	]
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

	referenceEntity := anObject
]

{ #category : #accessing }
MiSourceTextReference >> referenceText [

	^ referenceText
]

{ #category : #accessing }
MiSourceTextReference >> referenceText: anObject [

	referenceText := anObject asText
]

{ #category : #accessing }
MiSourceTextReference >> textBrowser [

	^ textBrowser
]

{ #category : #accessing }
MiSourceTextReference >> textBrowser: anObject [

	textBrowser := anObject
]
