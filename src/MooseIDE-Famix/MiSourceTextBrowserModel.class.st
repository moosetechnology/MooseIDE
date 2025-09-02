"
I am a model for the SourceTextBrowser

I take care of getting the source code for an entity and ""formatting"" it (actually finding where to apply formats: the highlights)

I also keep the displayedEntity and the selectedEntity (in the source code) if any
"
Class {
	#name : 'MiSourceTextBrowserModel',
	#superclass : 'MiAbstractModel',
	#instVars : [
		'displayedText',
		'selectedEntity',
		'highlights',
		'settings'
	],
	#category : 'MooseIDE-Famix-SourceText',
	#package : 'MooseIDE-Famix',
	#tag : 'SourceText'
}

{ #category : 'accessing' }
MiSourceTextBrowserModel >> addHighlight: aSourceTextHighlight [
	highlights add: aSourceTextHighlight
]

{ #category : 'highlights' }
MiSourceTextBrowserModel >> commentHighlightFor: aComment [

	self addHighlight: (MiSourceTextCommentHighlight new
		highlightedEntity: aComment ;
		yourself)

]

{ #category : 'highlights' }
MiSourceTextBrowserModel >> createHighlightsFor: anEntity [

	(anEntity class usesFamixTrait: FamixTComment)
	ifTrue: [
		self commentHighlightFor: anEntity.
		^self
	].

	(anEntity class usesFamixTrait: FamixTNamedEntity)
	ifTrue: [
		self identifierHighlightFor: anEntity
	].

	anEntity children do: [ :childChild |
		self createHighlightsFor: childChild ].

	(anEntity tags size = 1) ifTrue: [
		self tagHighlight: anEntity tags anyOne for: anEntity ].

	"aChildEntity queryAllOutgoing do: [:mseAssoc |
		mseAssoc allTargets do: [ :target | 	self addHighlight: (self dependencyHighlightFor: mseAssoc) ]
	]."
]

{ #category : 'highlights' }
MiSourceTextBrowserModel >> createKeywordHighlights [

	self selectedEntity mooseModel sourceLanguage languageKeyWords do: [ :kw || matcher |
		matcher := RxMatcher forString: ('\W' , kw , '\W').
		(matcher matchingRangesIn: self displayedText) do: [ :range |
			self keywordHighlightInterval: (range first + 1 to: range last - 1)
		]
	]
]

{ #category : 'accessing' }
MiSourceTextBrowserModel >> displayedEntity: anEntity [

	self selectedEntity: anEntity.

	self resetHighlights.
	self prepareFormating.
	browser renderTextFor: anEntity
]

{ #category : 'accessing' }
MiSourceTextBrowserModel >> displayedText [
	^displayedText
]

{ #category : 'accessing' }
MiSourceTextBrowserModel >> entities [
	^selectedEntity
		ifNil: [ #() ]
		ifNotNil: [ { selectedEntity } ]
]

{ #category : 'highlights' }
MiSourceTextBrowserModel >> errorHighlightInterval: anInterval [

	self addHighlight: (MiSourceTextErrorHighlight new
		highlightInterval: anInterval ;
		yourself)

]

{ #category : 'actions' }
MiSourceTextBrowserModel >> event: aMouseEvent selectedEntity: anEntity [

	self selectedEntity: anEntity.

	aMouseEvent controlKeyPressed
		ifTrue: [ anEntity inspect ]
]

{ #category : 'accessing' }
MiSourceTextBrowserModel >> highlights [
	^highlights
]

{ #category : 'highlights' }
MiSourceTextBrowserModel >> identifierHighlightFor: aChildEntity [
	
	self addHighlight: (MiSourceTextIdentifierHighlight new
		highlightedEntity: aChildEntity ;
		yourself)

]

{ #category : 'initialization' }
MiSourceTextBrowserModel >> initialize [
	super initialize.
	
	self resetHighlights
]

{ #category : 'settings' }
MiSourceTextBrowserModel >> initializeSettings [

	settings := super initializeSettings
		addItem: self itemWithHighlight named: #withHighlight ;
		yourself
]

{ #category : 'settings' }
MiSourceTextBrowserModel >> itemWithHighlight [

	^ MiAbstractSettingItem checkboxSetting
		  setValue: true ;
		  label: 'Highlight children in text?';
		  help:
			  'If checked the entity''s children are highlighted';
		  yourself
]

{ #category : 'highlights' }
MiSourceTextBrowserModel >> keywordHighlightInterval: anInterval [

	self addHighlight: (MiSourceTextKeywordHighlight new
		highlightInterval: anInterval ;
		yourself)

]

{ #category : 'accessing' }
MiSourceTextBrowserModel >> miSelectedItem [

	^self entities
]

{ #category : 'formatting' }
MiSourceTextBrowserModel >> noSourceCodeFor: anEntity [
	displayedText := ('There is no source code to show for {1}'
		format: { anEntity name }).

	self errorHighlightInterval: (Interval from: 37 to: displayedText size)
]

{ #category : 'highlights' }
MiSourceTextBrowserModel >> nullHighlightFor: aChildEntity [

]

{ #category : 'formatting' }
MiSourceTextBrowserModel >> prepareFormating [
	selectedEntity sourceText
		ifEmpty: [ self noSourceCodeFor: selectedEntity ]
		ifNotEmpty: [ :code | self prepareFormating: code ]

]

{ #category : 'formatting' }
MiSourceTextBrowserModel >> prepareFormating: aString [

	displayedText := aString.
	self withHighlight
		ifFalse: [self resetHighlights ]
		ifTrue: [
			self createHighlightsFor: self selectedEntity.
			self createKeywordHighlights ]
]

{ #category : 'highlights' }
MiSourceTextBrowserModel >> resetHighlights [

	highlights := OrderedCollection new
]

{ #category : 'accessing' }
MiSourceTextBrowserModel >> selectedEntity [
	^selectedEntity
]

{ #category : 'accessing' }
MiSourceTextBrowserModel >> selectedEntity: anEntity [

	selectedEntity := anEntity.
	browser updateToolbar
]

{ #category : 'settings' }
MiSourceTextBrowserModel >> settings [
	^settings
]

{ #category : 'settings' }
MiSourceTextBrowserModel >> settingsChanged: aBoolean [

	aBoolean ifFalse: [ ^self ].

	displayedText ifNotNil: [
		"nil when running some of the tests"
		self prepareFormating.
		self browser reRenderText
	]
]

{ #category : 'highlights' }
MiSourceTextBrowserModel >> tagHighlight: aTag for: anEntity [

	self addHighlight: (MiSourceTextTagHighlight new
		highlightedEntity: anEntity ;
		tag: aTag ;
		yourself)

]

{ #category : 'settings' }
MiSourceTextBrowserModel >> withHighlight [

	^settings getItemValue: #withHighlight
]
