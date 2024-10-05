"
I am a model for the SourceTextBrowser

I take care of getting the source code for an entity and ""formatting"" it (actually finding where to apply formats: the highlights)

I also keep the displayedEntity and the selectedEntity (in the source code) if any
"
Class {
	#name : #MiSourceTextBrowserModel,
	#superclass : #MiAbstractModel,
	#instVars : [
		'displayedText',
		'selectedEntity',
		'highlights',
		'settings'
	],
	#category : #'MooseIDE-Famix-SourceText'
}

{ #category : #accessing }
MiSourceTextBrowserModel >> addHighlight: aSourceTextHighlight [
	highlights add: aSourceTextHighlight
]

{ #category : #highlights }
MiSourceTextBrowserModel >> commentHighlightFor: aComment [

	^MiSourceTextCommentHighlight new
		highlightedEntity: aComment ;
		yourself.

]

{ #category : #accessing }
MiSourceTextBrowserModel >> displayedEntity: anEntity [

	self selectedEntity: anEntity.

	self resetHighlights.
	self prepareFormating.
	browser renderTextFor: anEntity
]

{ #category : #accessing }
MiSourceTextBrowserModel >> displayedText [
	^displayedText
]

{ #category : #accessing }
MiSourceTextBrowserModel >> entities [
	^selectedEntity
		ifNil: [ #() ]
		ifNotNil: [ { selectedEntity } ]
]

{ #category : #highlights }
MiSourceTextBrowserModel >> errorHighlightInterval: anInterval [

		^MiSourceTextErrorHighlight new
		interval: anInterval ;
		yourself.

]

{ #category : #actions }
MiSourceTextBrowserModel >> event: aMouseEvent selectedEntity: anEntity [

	self selectedEntity: anEntity.

	aMouseEvent controlKeyPressed
		ifTrue: [ anEntity inspect ]
]

{ #category : #highlights }
MiSourceTextBrowserModel >> gatherHighlights [
	self selectedEntity children do: [ :child |
		self gatherHighlightsForEntity: child
	]
]

{ #category : #highlights }
MiSourceTextBrowserModel >> gatherHighlightsForEntity: aChildEntity [

	self addHighlight: (self identifierHighlightFor: aChildEntity).

	(aChildEntity mooseDescription allProperties anySatisfy: [ :prop | prop implementingSelector = #comments ])
		ifTrue: [ aChildEntity comments
			do: [ :cmt | 	self addHighlight: (self commentHighlightFor: cmt) ]
		].

	aChildEntity tags do: [ :childTag | self addHighlight: (self tagHighlightFor: childTag) ].

	aChildEntity children do: [ :childChild |
		self gatherHighlightsForEntity: childChild ].

	aChildEntity queryAllOutgoing do: [:mseAssoc |
		mseAssoc allTargets do: [ :target | 	self addHighlight: (self tagHighlightFor: mseAssoc) ]
	].
]

{ #category : #accessing }
MiSourceTextBrowserModel >> highlights [
	^highlights
]

{ #category : #highlights }
MiSourceTextBrowserModel >> identifierHighlightFor: aChildEntity [
	
	^MiSourceTextIdentifierHighlight new
		highlightedEntity: aChildEntity ;
		yourself.

]

{ #category : #initialization }
MiSourceTextBrowserModel >> initialize [
	super initialize.
	
	self resetHighlights
]

{ #category : #settings }
MiSourceTextBrowserModel >> initializeSettings [

	settings := super initializeSettings
		addItem: self itemWithHighlight named: #withHighlight ;
		yourself
]

{ #category : #settings }
MiSourceTextBrowserModel >> itemWithHighlight [

	^ MiAbstractSettingItem checkboxSetting
		  setValue: true ;
		  label: 'Highlight children in text?';
		  help:
			  'If checked the entity''s children are highlighted';
		  yourself
]

{ #category : #accessing }
MiSourceTextBrowserModel >> miSelectedItem [

	^self entities
]

{ #category : #formatting }
MiSourceTextBrowserModel >> noSourceCodeFor: anEntity [
	displayedText := ('There is no source code to show for {1}'
		format: { anEntity name }).

	self errorHighlightInterval: (Interval from: 37 to: displayedText size)
]

{ #category : #highlights }
MiSourceTextBrowserModel >> nullHighlightFor: aChildEntity [

	^MiSourceTextNullHighlight new
		highlightedEntity: aChildEntity;
		yourself.

]

{ #category : #formatting }
MiSourceTextBrowserModel >> prepareFormating [
	selectedEntity sourceText
		ifEmpty: [ self noSourceCodeFor: selectedEntity ]
		ifNotEmpty: [ :code | self prepareFormating: code ]

]

{ #category : #formatting }
MiSourceTextBrowserModel >> prepareFormating: aString [

	displayedText := aString.
	self withHighlight
		ifTrue: [ self gatherHighlights ]
		ifFalse: [self resetHighlights ]
]

{ #category : #accessing }
MiSourceTextBrowserModel >> resetHighlights [

	highlights := OrderedCollection new
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

{ #category : #settings }
MiSourceTextBrowserModel >> settings [
	^settings
]

{ #category : #settings }
MiSourceTextBrowserModel >> settingsChanged: aBoolean [

	aBoolean ifTrue: [
		self prepareFormating.
		self browser reRenderText
	]
]

{ #category : #highlights }
MiSourceTextBrowserModel >> tagHighlightFor: anEntity [

	^MiSourceTextTagHighlight new
		highlightedEntity: anEntity ;
		yourself.

]

{ #category : #settings }
MiSourceTextBrowserModel >> withHighlight [

	^settings getItemValue: #withHighlight
]
