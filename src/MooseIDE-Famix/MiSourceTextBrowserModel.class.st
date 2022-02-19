"
I am a model for the SourceTextBrowser

I take care of getting the source code for an entity and ""formatting"" it (actually finding where to apply formats: the highlights)

I also keep the displayedEntity and the selectedEntity (in the source code) if any
"
Class {
	#name : #MiSourceTextBrowserModel,
	#superclass : #Object,
	#instVars : [
		'browser',
		'displayedEntity',
		'displayedText',
		'selectedEntity',
		'highlights'
	],
	#category : #'MooseIDE-Famix-SourceText'
}

{ #category : #highlights }
MiSourceTextBrowserModel >> addErrorHighlightInterval: anInterval [
	self addHighlight: (MiSourceTextErrorHighlight new
		interval: anInterval ;
		yourself)
]

{ #category : #highlights }
MiSourceTextBrowserModel >> addHighlight: aSourceTextHighlight [
	highlights add: aSourceTextHighlight
]

{ #category : #highlights }
MiSourceTextBrowserModel >> addIdentifierHighlightFor: aChildEntity interval: childInterval in: aString [
	self addHighlight: (MiSourceTextIdentifierHighlight new
		highlightedEntity: aChildEntity ;
		setInterval: childInterval in: aString ;
		yourself)
]

{ #category : #highlights }
MiSourceTextBrowserModel >> addNullHighlightFor: aChildEntity [
	self addHighlight: (MiSourceTextNullHighlight new
		highlightedEntity: aChildEntity;
		yourself)
]

{ #category : #highlights }
MiSourceTextBrowserModel >> addTagHighlightFor: aChildEntity interval: childInterval [
	self addHighlight: (MiSourceTextTagHighlight new
		highlightedEntity: aChildEntity ;
		interval: childInterval ;
		yourself)
]

{ #category : #accessing }
MiSourceTextBrowserModel >> browser: aMiBrowser [
	browser := aMiBrowser 
]

{ #category : #accessing }
MiSourceTextBrowserModel >> displayedEntity [
	"the entity which source code is shown in the browser"
	^ displayedEntity
]

{ #category : #accessing }
MiSourceTextBrowserModel >> displayedEntity: anObject [
	displayedEntity := anObject.
	selectedEntity := anObject.
	self formatSource 
]

{ #category : #accessing }
MiSourceTextBrowserModel >> displayedText [
	^displayedText
]

{ #category : #formatting }
MiSourceTextBrowserModel >> formatSource [
	displayedEntity sourceText
		ifEmpty: [ self noSourceCodeFor: displayedEntity ]
		ifNotEmpty: [ :code | self formatSource: code ]

]

{ #category : #formatting }
MiSourceTextBrowserModel >> formatSource: aString [
	displayedText := aString.
	self gatherHighlights
]

{ #category : #highlights }
MiSourceTextBrowserModel >> gatherHighlights [
	self displayedEntity children do: [ :child |
		self gatherHighlightsFor: child
	]
]

{ #category : #highlights }
MiSourceTextBrowserModel >> gatherHighlightsFor: aChildEntity [

	self displayedEntity sourceAnchor
	ifNotNil: [ :referenceAnchor |
		(referenceAnchor textIntervalForChild: aChildEntity)
		ifNotNil: [ :childInterval | 
			self addIdentifierHighlightFor: aChildEntity interval: childInterval in: displayedText.
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
MiSourceTextBrowserModel >> highlights [
	^highlights
]

{ #category : #initialization }
MiSourceTextBrowserModel >> initialize [
	super initialize.
	
	highlights := OrderedCollection new
]

{ #category : #formatting }
MiSourceTextBrowserModel >> noSourceCodeFor: anEntity [
	displayedText := ('There is no source code to show for {1}'
		format: { anEntity name }).

	self addErrorHighlightInterval: (Interval from: 1 to: 35)
]

{ #category : #formatting }
MiSourceTextBrowserModel >> noSourceCodeMessageFor: anEntity [
	| text |
	text := ('There is no source code to show for {1}'
		format: { anEntity name })
		asText.
	text addAttribute: (TextColor red) from: 1 to: 35.
	^text
]

{ #category : #accessing }
MiSourceTextBrowserModel >> selectedEntity [
	^selectedEntity
]

{ #category : #accessing }
MiSourceTextBrowserModel >> selectedEntity: anEntity [
	selectedEntity := anEntity.
	browser updateToolbar 
]
