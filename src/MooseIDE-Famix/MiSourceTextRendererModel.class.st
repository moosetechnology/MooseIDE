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
		'renderer',
		'sourceAnchorAdapter'
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

{ #category : 'highlights' }
MiSourceTextRendererModel >> addCommentHighlight: aComment [

	self
		addHighlight: MiSourceTextCommentHighlight
		interval: (sourceAnchorAdapter intervalForEntity: aComment)
]

{ #category : 'highlights' }
MiSourceTextRendererModel >> addErrorHighlight: anInterval [

	self
		addHighlight: MiSourceTextErrorHighlight
		interval: anInterval

]

{ #category : 'highlights' }
MiSourceTextRendererModel >> addHighlight: highlightClass interval: anInterval [
	
	| highlight |

	highlight := highlightClass new
		highlightInterval: anInterval ;
		yourself.

	highlights add: highlight.

	^highlight

]

{ #category : 'highlights' }
MiSourceTextRendererModel >> addIdentifierHighlight: anEntity [

	(self
		addHighlight: MiSourceTextIdentifierHighlight 
		interval: (sourceAnchorAdapter intervalForEntity: anEntity))
		highlightedEntity: anEntity
]

{ #category : 'highlights' }
MiSourceTextRendererModel >> addKeywordHighlight: anInterval [

	self
		addHighlight: MiSourceTextKeywordHighlight 
		interval: anInterval 
]

{ #category : 'highlights' }
MiSourceTextRendererModel >> clearHighlightsInComments [

	self highlights copy do: [ :highlight |
		(highlight class = MiSourceTextCommentHighlight)
			ifTrue: [
				self clearNoncommentHighlightFrom: highlight from to: highlight to
			]
	]
]

{ #category : 'highlights' }
MiSourceTextRendererModel >> clearNoncommentHighlightFrom: startPos to: endPos [

	self highlights
		removeAll: ((self highlightIncludedIn: startPos to: endPos)
			reject: [:hglhgt | hglhgt class = MiSourceTextCommentHighlight])
]

{ #category : 'highlights' }
MiSourceTextRendererModel >> createEntitiesHighlightsFor: anEntity [
	"note: checks if anEntity is a comment first
	 if so: apply comment formatting, and leave to avoid adding any other one"

	(anEntity class usesFamixTrait: FamixTComment) ifTrue: [
			self addCommentHighlight: anEntity.
			^ self ].

	(anEntity class usesFamixTrait: FamixTNamedEntity) ifTrue: [
		self addIdentifierHighlight: anEntity ].

	anEntity containedEntities do: [ :child |
		self createEntitiesHighlightsFor: child ].

	(anEntity tags size = 1) ifTrue: [
		self addTagHighlight: anEntity tags anyOne on: anEntity ].

	anEntity queryAllOutgoing do: [:mseAssoc |
		mseAssoc sourceAnchor ifNotNil: [ :usedAnchor |
			mseAssoc allTargets
				detect: [ :target | target isStub not ]
				ifOne: [ :target | self addIdentifierHighlight: mseAssoc ]
		]
	]

]

{ #category : 'highlights' }
MiSourceTextRendererModel >> createHighlights [

	self resetHighlights.

	self shouldHighlightChildren
		ifFalse: [ ^self ].

	self prepareSourceAnchorAdapter.
	self createKeywordHighlights.
	self createEntitiesHighlightsFor: entity.
	self clearHighlightsInComments
]

{ #category : 'highlights' }
MiSourceTextRendererModel >> createKeywordHighlights [
	"search for all sourceLanguage keywords in the displayedText and highlight them
	There are several guard conditions because this feature is work in progress and
	not all language implement it"

	entity mooseModel
	ifNotNil: [ :mooseModel |
		mooseModel sourceLanguage
		ifNotNil: [ :sourceLanguage |
			sourceLanguage languageKeyWords do: [ :kw | self createKeywordHighlightsFor: kw ]
		]
	]
]

{ #category : 'highlights' }
MiSourceTextRendererModel >> createKeywordHighlightsFor: aKeyWord [
	"Search for a keyword in the displayedText and creates a keyWordHighlight for it
	 keywords should be whole words (after and before a word separator) or strat the text or end it"

	| matcher |

	(self displayedText beginsWith: aKeyWord) 
		ifTrue: [ self addKeywordHighlight: (1 to: aKeyWord size) ].

	matcher := RxMatcher forString: ('\W' , aKeyWord , '\W').
	(matcher matchingRangesIn: self displayedText) do: [ :range |
		self addKeywordHighlight: (range first + 1 to: range last - 1)
	].

	(self displayedText endsWith: aKeyWord) 
		ifTrue: [ | intervalEnd |
			intervalEnd := self displayedText size.
			self addKeywordHighlight: ((intervalEnd - aKeyWord size) to: intervalEnd) ].

]

{ #category : 'accessing' }
MiSourceTextRendererModel >> displayedText [
	^displayedText
]

{ #category : 'accessing' }
MiSourceTextRendererModel >> entity: anEntity [
]

{ #category : 'formatting' }
MiSourceTextRendererModel >> entitySourceText [
	^entity sourceText
		ifEmpty: [
			self noSourceCodeFor: entity.
			false ]
		ifNotEmpty: [ :code |
			displayedText := code.
			true ]

]

{ #category : 'highlights' }
MiSourceTextRendererModel >> highlightIncludedIn: startPos to: endPos [

	^self highlights select: [ :hglght |
		(hglght from >= startPos) and: [ hglght to <= endPos ]
	]
]

{ #category : 'accessing' }
MiSourceTextRendererModel >> highlights [
	^highlights
]

{ #category : 'initialization' }
MiSourceTextRendererModel >> initialize [
	super initialize.

	shouldHighlightChildren := true.
	sourceAnchorAdapter := MiSourceTextNullAdapter new.

	self resetHighlights.


]

{ #category : 'formatting' }
MiSourceTextRendererModel >> noSourceCodeFor: anEntity [
	displayedText := ('There is no source code to show for {1}'
		format: { anEntity name }).

	self addErrorHighlight: (Interval from: 37 to: displayedText size)
]

{ #category : 'highlights' }
MiSourceTextRendererModel >> prepareSourceAnchorAdapter [

	sourceAnchorAdapter := MiAbstractSourceTextAnchorAdapter adapterFor: entity.
	sourceAnchorAdapter initializeDisplayedText: displayedText andEntity: entity.
]

{ #category : 'formatting' }
MiSourceTextRendererModel >> renderTextFor: anEntity [

	entity := anEntity.

	self entitySourceText
		ifTrue: [ self createHighlights ].

	renderer renderText
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

	(self
		addHighlight: MiSourceTextTagHighlight
		interval: (sourceAnchorAdapter intervalForEntity: anEntity))
		color: aTag color
]
