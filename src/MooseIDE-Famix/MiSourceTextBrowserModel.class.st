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

{ #category : #actions }
MiSourceTextBrowserModel >> event: aMouseEvent selectedEntity: anEntity [

	self selectedEntity: anEntity.

	aMouseEvent controlKeyPressed
		ifTrue: [ anEntity inspect ]
]

{ #category : #formatting }
MiSourceTextBrowserModel >> gatherHighlights [

	MiSourceTextAbstractHighlightBuilder new
		model: self ;
		createHighlightsFor: self selectedEntity
]

{ #category : #accessing }
MiSourceTextBrowserModel >> highlights [
	^highlights
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

{ #category : #formatting }
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

	aBoolean ifFalse: [ ^self ].

	self prepareFormating.
	self browser reRenderText

]

{ #category : #settings }
MiSourceTextBrowserModel >> withHighlight [

	^settings getItemValue: #withHighlight
]
