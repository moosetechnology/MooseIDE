"
I am a model for the SourceTextBrowser

I take care of getting the source code for an entity and formatting it or setting hyperlinks
"
Class {
	#name : #MiSourceTextBrowserModel,
	#superclass : #Object,
	#instVars : [
		'displayed',
		'selected',
		'browser',
		'textReference'
	],
	#category : #'MooseIDE-Famix-SourceText'
}

{ #category : #accessing }
MiSourceTextBrowserModel >> browser: aMiBrowser [
	browser := aMiBrowser 
]

{ #category : #formatting }
MiSourceTextBrowserModel >> createSourceTextReference [

	textReference := (displayed sourceText
		ifEmpty: [ MiSourceTextVoidReference new ]
		ifNotEmpty: [ MiSourceTextReference new
			referenceText: displayed sourceText ]).
	textReference
		referenceEntity: displayed ;
		uiModel: self.
	^textReference
]

{ #category : #accessing }
MiSourceTextBrowserModel >> displayedEntity [
	"the entity which source code is shown in the browser"
	^ displayed
]

{ #category : #accessing }
MiSourceTextBrowserModel >> displayedEntity: anObject [
	displayed := anObject.
	selected := anObject
]

{ #category : #formatting }
MiSourceTextBrowserModel >> formatSource [
	^self createSourceTextReference
		gatherHighlights;
		yourself
]

{ #category : #formatting }
MiSourceTextBrowserModel >> highlightInterval: aTextInterval inText: mainText [
	| start end childEntity |
	start := aTextInterval first.
	end := aTextInterval last.
	childEntity := aTextInterval entity.
	mainText
		addAttribute: TextEmphasis underlined from: start to: end ;
		addAttribute: TextEmphasis italic from: start to: end ;
		addAttribute: (TextDoIt new
			actOnClickBlock: [ self selected: childEntity ])  from: start to: end
		"addAttribute: TextColor black  from: start to: end ".
				
	childEntity tags do: [ :tag |
		mainText
			addAttribute: (TextBackgroundColor color: (tag color)) from: start to: end
	]

]

{ #category : #accessing }
MiSourceTextBrowserModel >> highlights [
	^textReference highlights
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
MiSourceTextBrowserModel >> selected [
	"an entity selected (clicked upon) in the source code of the #displayedEntity"
	^ selected
]

{ #category : #accessing }
MiSourceTextBrowserModel >> selected: anEntity [
	selected := anEntity.
	browser updateToolbar 
]

{ #category : #accessing }
MiSourceTextBrowserModel >> selectedEntity [
	^ selected
]

{ #category : #accessing }
MiSourceTextBrowserModel >> sourceText [
	^ displayed sourceText
]
