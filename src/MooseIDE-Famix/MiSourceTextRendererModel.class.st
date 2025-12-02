"
I am a model for the SourceTextBrowser

I take care of getting the source code for an entity and ""formatting"" it (actually finding where to apply formats: the highlights)

I also keep the displayedEntity and the selectedEntity (in the source code) if any
"
Class {
	#name : 'MiSourceTextRendererModel',
	#superclass : 'Object',
	#instVars : [
		'displayedText',
		'highlights',
		'shouldHighlightChildren',
		'entity',
		'renderer'
	],
	#category : 'MooseIDE-Famix-SourceText',
	#package : 'MooseIDE-Famix',
	#tag : 'SourceText'
}

{ #category : 'accessing' }
MiSourceTextRendererModel class >> defaultConfiguration [

	^ MiSourceTextSettingsConfiguration new
		  shouldHighlightChildren: self defaultShouldHighlightChildren;
		  yourself
]

{ #category : 'as yet unclassified' }
MiSourceTextRendererModel class >> defaultShouldHighlightChildren [

	^ true
]

{ #category : 'accessing' }
MiSourceTextRendererModel >> addHighlight: aSourceTextHighlight [
	highlights add: aSourceTextHighlight
]

{ #category : 'highlights' }
MiSourceTextRendererModel >> commentHighlightFor: aComment [

	self addHighlight: (MiSourceTextCommentHighlight new
		highlightedEntity: aComment ;
		yourself)

]

{ #category : 'highlights' }
MiSourceTextRendererModel >> createHighlightsFor: anEntity [
	"note: checks if anEntity is a comment first
	 if so: apply comment formatting, and leave to not add any other one"

	(anEntity class usesFamixTrait: FamixTComment) ifTrue: [
			self commentHighlightFor: anEntity.
			^ self ].

	(anEntity class usesFamixTrait: FamixTNamedEntity) ifTrue: [
		self identifierHighlightFor: anEntity ].

	anEntity containedEntities do: [ :childChild |
		self createHighlightsFor: childChild ].

	anEntity tags size = 1 ifTrue: [
		self tagHighlight: anEntity tags anyOne for: anEntity ]

	"aChildEntity queryAllOutgoing do: [:mseAssoc |
		mseAssoc allTargets do: [ :target | 	self addHighlight: (self dependencyHighlightFor: mseAssoc) ]
	]."
]

{ #category : 'highlights' }
MiSourceTextRendererModel >> createLanguageKeywordHighlights [
	"search for all sourceLanguage keywords in the displayedText and highlight them
	There are several guard conditions because this feature is work in progress and
	not all language implement it"

	entity mooseModel
	ifNotNil: [ :mooseModel |
		mooseModel sourceLanguage
		ifNotNil: [ :sourceLanguage |
			sourceLanguage languageKeyWords do: [ :kw || matcher |
				matcher := RxMatcher forString: ('\W' , kw , '\W').
				(matcher matchingRangesIn: self displayedText) do: [ :range |
					self keywordHighlightInterval: (range first + 1 to: range last - 1)
				]
			]
		]
	]
]

{ #category : 'accessing' }
MiSourceTextRendererModel >> displayedText [
	^displayedText
]

{ #category : 'accessing' }
MiSourceTextRendererModel >> entity: anEntity [
]

{ #category : 'highlights' }
MiSourceTextRendererModel >> errorHighlightInterval: anInterval [

	self addHighlight: (MiSourceTextErrorHighlight new
		highlightInterval: anInterval ;
		yourself)

]

{ #category : 'accessing' }
MiSourceTextRendererModel >> highlights [
	^highlights
]

{ #category : 'highlights' }
MiSourceTextRendererModel >> identifierHighlightFor: aChildEntity [
	
	self addHighlight: (MiSourceTextIdentifierHighlight new
		highlightedEntity: aChildEntity ;
		yourself)

]

{ #category : 'initialization' }
MiSourceTextRendererModel >> initialize [
	super initialize.

	shouldHighlightChildren := true
]

{ #category : 'highlights' }
MiSourceTextRendererModel >> keywordHighlightInterval: anInterval [

	self addHighlight: (MiSourceTextKeywordHighlight new
		highlightInterval: anInterval ;
		yourself)

]

{ #category : 'formatting' }
MiSourceTextRendererModel >> noSourceCodeFor: anEntity [
	displayedText := ('There is no source code to show for {1}'
		format: { anEntity name }).

	self errorHighlightInterval: (Interval from: 37 to: displayedText size)
]

{ #category : 'highlights' }
MiSourceTextRendererModel >> nullHighlightFor: aChildEntity [

]

{ #category : 'formatting' }
MiSourceTextRendererModel >> prepareFormating [
	entity sourceText
		ifEmpty: [ self noSourceCodeFor: entity ]
		ifNotEmpty: [ :code | self prepareFormating: code ]

]

{ #category : 'formatting' }
MiSourceTextRendererModel >> prepareFormating: aString [

	displayedText := aString.

	self shouldHighlightChildren
		ifTrue: [
			self createLanguageKeywordHighlights.
			self createHighlightsFor: entity ]
		ifFalse: [ self resetHighlights ]
]

{ #category : 'formatting' }
MiSourceTextRendererModel >> renderTextFor: anEntity [

	entity := anEntity.

	self resetHighlights.
	self prepareFormating.

	renderer renderTextFor: entity 
]

{ #category : 'accessing' }
MiSourceTextRendererModel >> renderer: aUIRenderer [

	renderer := aUIRenderer 
]

{ #category : 'highlights' }
MiSourceTextRendererModel >> resetHighlights [

	highlights := OrderedCollection new
]

{ #category : 'accessing' }
MiSourceTextRendererModel >> shouldHighlightChildren [

	^shouldHighlightChildren
]

{ #category : 'accessing' }
MiSourceTextRendererModel >> shouldHighlightChildren: aBoolean [

	shouldHighlightChildren := aBoolean 
]

{ #category : 'highlights' }
MiSourceTextRendererModel >> tagHighlight: aTag for: anEntity [

	self addHighlight: (MiSourceTextTagHighlight new
		highlightedEntity: anEntity ;
		tag: aTag ;
		yourself)

]
