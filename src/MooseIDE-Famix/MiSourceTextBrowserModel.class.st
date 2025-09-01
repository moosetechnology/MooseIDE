"
I am a model for the SourceTextBrowser

I take care of getting the source code for an entity and ""formatting"" it (actually finding where to apply formats: the highlights)

I also keep the displayedEntity and the selectedEntity (in the source code) if any
"
Class {
	#name : 'MiSourceTextBrowserModel',
	#superclass : 'MiAbstractModel',
	#traits : 'MiTSpecModelWithSettings',
	#classTraits : 'MiTSpecModelWithSettings classTrait',
	#instVars : [
		'displayedText',
		'highlights',
		'shouldHighlightChildren',
		'entity'
	],
	#category : 'MooseIDE-Famix-SourceText',
	#package : 'MooseIDE-Famix',
	#tag : 'SourceText'
}

{ #category : 'as yet unclassified' }
MiSourceTextBrowserModel class >> defaultShouldHighlightChildren [

	^ true
]

{ #category : 'accessing' }
MiSourceTextBrowserModel class >> newMementoForDefaultValues [

	^ MiSourceTextMemento new
		  shouldHighlightChildren: self defaultShouldHighlightChildren;
		  yourself
]

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

	^ entity ifNil: [ #(  ) ] ifNotNil: [ { entity } ]
]

{ #category : 'accessing' }
MiSourceTextBrowserModel >> entity: anEntity [
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

{ #category : 'initialization' }
MiSourceTextBrowserModel >> initializeSettings [

	shouldHighlightChildren := self class defaultShouldHighlightChildren
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

{ #category : 'accessing' }
MiSourceTextBrowserModel >> miSelectedItem [

	^self entities
]

{ #category : 'settings management' }
MiSourceTextBrowserModel >> newMemento [

	^ MiSourceTextMemento new
		  shouldHighlightChildren: shouldHighlightChildren;
		  yourself
]

{ #category : 'settings management' }
MiSourceTextBrowserModel >> newMementoForDefaultValues [

	^ self class newMementoForDefaultValues
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
	entity sourceText
		ifEmpty: [ self noSourceCodeFor: entity ]
		ifNotEmpty: [ :code | self prepareFormating: code ]

]

{ #category : 'formatting' }
MiSourceTextBrowserModel >> prepareFormating: aString [

	displayedText := aString.

	shouldHighlightChildren
		ifTrue: [ self createHighlightsFor: self selectedEntity ]
		ifFalse: [ self resetHighlights ]
]

{ #category : 'highlights' }
MiSourceTextBrowserModel >> resetHighlights [

	highlights := OrderedCollection new
]

{ #category : 'accessing' }
MiSourceTextBrowserModel >> selectedEntity [
	^entity
]

{ #category : 'accessing' }
MiSourceTextBrowserModel >> selectedEntity: anEntity [

	entity := anEntity.
	browser updateToolbar
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

{ #category : 'settings management' }
MiSourceTextBrowserModel >> settingsPresenterExtent [
	"Override to set a custom size"

	^ 350 @ 200
]

{ #category : 'highlights' }
MiSourceTextBrowserModel >> tagHighlight: aTag for: anEntity [

	self addHighlight: (MiSourceTextTagHighlight new
		highlightedEntity: anEntity ;
		tag: aTag ;
		yourself)

]

{ #category : 'settings management' }
MiSourceTextBrowserModel >> updateFromMemento: aMemento [

	shouldHighlightChildren := aMemento shouldHighlightChildren.

	self resetHighlights.
	self prepareFormating.
	browser renderTextFor: entity
]
