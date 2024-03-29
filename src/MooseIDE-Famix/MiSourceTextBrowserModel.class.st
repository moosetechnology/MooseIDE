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
		'highlights'
	],
	#category : #'MooseIDE-Famix-SourceText'
}

{ #category : #highlights }
MiSourceTextBrowserModel >> addErrorHighlightInterval: anInterval [
	| highlight |
	highlight := MiSourceTextErrorHighlight new
		interval: anInterval ;
		yourself.
	self addHighlight: highlight.
	^highlight
]

{ #category : #highlights }
MiSourceTextBrowserModel >> addHighlight: aSourceTextHighlight [
	highlights add: aSourceTextHighlight
]

{ #category : #highlights }
MiSourceTextBrowserModel >> addIdentifierHighlightFor: aChildEntity interval: childInterval [
	| highlight |
	highlight := MiSourceTextIdentifierHighlight new
		highlightedEntity: aChildEntity ;
		interval: childInterval ;
		restrictIntervalTo: aChildEntity name in: self displayedText ;
		yourself.
	self addHighlight: highlight.
	^highlight 
]

{ #category : #highlights }
MiSourceTextBrowserModel >> addNullHighlightFor: aChildEntity [
	| highlight |
	highlight := MiSourceTextNullHighlight new
		highlightedEntity: aChildEntity;
		yourself.
	self addHighlight: highlight.
	^highlight
]

{ #category : #highlights }
MiSourceTextBrowserModel >> addTagHighlightFor: aChildEntity interval: childInterval [
	| highlight |
	highlight := MiSourceTextTagHighlight new
		highlightedEntity: aChildEntity ;
		interval: childInterval ;
		yourself.
	self addHighlight: highlight.
	^highlight

]

{ #category : #accessing }
MiSourceTextBrowserModel >> displayedEntity: anObject [

	selectedEntity := anObject.
	self resetHighlights.

	self formatSource 
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

{ #category : #formatting }
MiSourceTextBrowserModel >> formatSource [
	selectedEntity sourceText
		ifEmpty: [ self noSourceCodeFor: selectedEntity ]
		ifNotEmpty: [ :code | self formatSource: code ]

]

{ #category : #formatting }
MiSourceTextBrowserModel >> formatSource: aString [
	displayedText := aString.
	self gatherHighlights
]

{ #category : #highlights }
MiSourceTextBrowserModel >> gatherHighlights [
	self selectedEntity children do: [ :child |
		self gatherHighlightsForEntity: child
	]
]

{ #category : #highlights }
MiSourceTextBrowserModel >> gatherHighlightsForEntity: aChildEntity [

	self selectedEntity sourceAnchor
	ifNotNil: [ :referenceAnchor |
		(self identifierIntervalFor: aChildEntity inside: referenceAnchor)
		ifNotNil: [ :childInterval | 
			self addIdentifierHighlightFor: aChildEntity interval: childInterval.
			aChildEntity tags do: [ :childTag |
				(self addTagHighlightFor: childTag interval: childInterval)
					restrictIntervalTo: aChildEntity name in: self displayedText.
			]
		].
		aChildEntity children do: [ :childChild |
			self gatherHighlightsForEntity: childChild ].

		aChildEntity queryAllOutgoing do: [:mseAssoc |
			mseAssoc allTargets do: [ :target |
				target tags do: [ :assocTag |
					(referenceAnchor textIntervalForChild: mseAssoc)
					ifNotNil: [ :assocInterval |
						self addTagHighlightFor: assocTag interval: assocInterval.
					]
				]
			]
		].
		"-- Not sure, but it may be that highlighting associations (just above) is enough --

		aChildEntity outgoingMSEProperties do: [:prop |
			prop isChildrenProperty ifFalse: [
				prop isContainer ifFalse: [ 
					(aChildEntity perform: (prop implementingSelector)) do: [ :assoc |
						assoc allTargets do: [ :target |
							target tags do: [ :assocTag |
								(referenceAnchor textIntervalForChild: assoc)
								ifNotNil: [ :assocInterval |
									self addTagHighlightFor: assocTag interval: assocInterval.
								]
							]
						]
					]
				]
			]
		]"
	]
]

{ #category : #accessing }
MiSourceTextBrowserModel >> highlights [
	^highlights
]

{ #category : #highlights }
MiSourceTextBrowserModel >> identifierIntervalFor: aChildEntity inside: referenceAnchor [
	"returns the interval in #displayedText for the 1st line containing aChildEntity identifier
	 referenceanchor is the anchor of the #displayedEntity and is used to find where aChildEntity
	 is within #displayedText"
	^(referenceAnchor textIntervalForChild: aChildEntity)
	ifNotNil: [ :childInterval | | childStart |
		childStart := displayedText
			findString: aChildEntity name
			startingAt: childInterval first.

		Interval
			from: childStart
			to: (childStart + aChildEntity name size - 1)
  ]
]

{ #category : #initialization }
MiSourceTextBrowserModel >> initialize [
	super initialize.
	
	self resetHighlights
]

{ #category : #accessing }
MiSourceTextBrowserModel >> miSelectedItem [

	^self entities
]

{ #category : #formatting }
MiSourceTextBrowserModel >> noSourceCodeFor: anEntity [
	displayedText := ('There is no source code to show for {1}'
		format: { anEntity name }).

	self addErrorHighlightInterval: (Interval from: 37 to: displayedText size)
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
