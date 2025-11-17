"
A renderer of highlighted source text using Spec SpTextPresenter.
Ideally it would be subclass of a MiSourceTextAbstractRenderer, but it also need to inherit from SpTextPresenter

A renderer has a MiSourceTextBrowserModel and a browser.
It can #renderText by applying the highlights of its #model
"
Class {
	#name : 'MiSourceTextSpecRenderer',
	#superclass : 'SpTextPresenter',
	#instVars : [
		'formatedText',
		'sourceAnchorAdapter',
		'rendererModel'
	],
	#category : 'MooseIDE-Famix-SourceText',
	#package : 'MooseIDE-Famix',
	#tag : 'SourceText'
}

{ #category : 'formatting' }
MiSourceTextSpecRenderer >> applyCommentHighlight: aHighlight [
	"remove all other attributes on comments and set color attribute to grey"

	self clearFormatingFrom: aHighlight from to: aHighlight to.

	formatedText
		addAttribute: TextColor gray
		from: aHighlight from
		to: aHighlight to.

]

{ #category : 'formatting' }
MiSourceTextSpecRenderer >> applyErrorHighlight: aHighlight [

	formatedText 
		addAttribute: TextColor red
		from: aHighlight from
		to: aHighlight to
]

{ #category : 'formatting' }
MiSourceTextSpecRenderer >> applyIdentifierHighlight: aHighlight [
	"Identifiers are underlined + italic + bold
	 Clicking on them is passed on to the spec model"

	formatedText 
		addAttribute: TextEmphasis underlined
		from: aHighlight from
		to: aHighlight to ;

		"addAttribute: TextEmphasis italic
		from: aHighlight from
		to: aHighlight to ;"
		
		"addAttribute: TextEmphasis bold
		from: aHighlight from
		to: aHighlight to ;"

		addAttribute:
			(TextDoIt new actOnClickBlock: [ :ignored :event |
				self event: event selectedEntity: aHighlight highlightedEntity ])
		from: aHighlight from
		to: aHighlight to ";"

		"addAttribute: TextColor black
		from: aHighlight from
		to: aHighlight to"

]

{ #category : 'formatting' }
MiSourceTextSpecRenderer >> applyKeywordHighlight: aHighlight [

	formatedText 
		addAttribute: TextColor magenta
		from: aHighlight from
		to: aHighlight to
]

{ #category : 'formatting' }
MiSourceTextSpecRenderer >> applyTagHighlight: aHighlight [

	formatedText
		addAttribute: (TextColor color: aHighlight tag color)
		from: aHighlight from
		to: aHighlight to
]

{ #category : 'accessing' }
MiSourceTextSpecRenderer >> browser [
	^self owner
]

{ #category : 'formatting' }
MiSourceTextSpecRenderer >> clearFormating [

	formatedText := formatedText asString asText
]

{ #category : 'formatting' }
MiSourceTextSpecRenderer >> clearFormatingFrom: start to: stop [

	formatedText := formatedText copyReplaceFrom: start to: stop with: (formatedText copyFrom: start to: stop) asString
]

{ #category : 'actions' }
MiSourceTextSpecRenderer >> event: anEvent selectedEntity: anEntity [

	rendererModel event: anEvent selectedEntity: anEntity.
	self inform: 'Selected entity: ' , anEntity asString
]

{ #category : 'private - testing' }
MiSourceTextSpecRenderer >> formatedText [
	^formatedText 
]

{ #category : 'initialization' }
MiSourceTextSpecRenderer >> initialize [
	super initialize.
	self beNotEditable.

	sourceAnchorAdapter := MiSourceTextNullAdapter new
]

{ #category : 'rendering' }
MiSourceTextSpecRenderer >> reRenderText [
	"Apply highlights if needed
	 Re-display (requires to clear the text first)"

	self clearFormating.

	rendererModel highlights do: [ :hlght |
			hlght adaptSourceAnchorWith: self sourceAnchorAdapter.
			hlght hasInterval ifTrue: [ hlght applyTo: self ] ].

	self clearContent.
	self text: formatedText
]

{ #category : 'rendering' }
MiSourceTextSpecRenderer >> renderTextFor: anEntity [
	
	formatedText := rendererModel displayedText asText.
	sourceAnchorAdapter := MiAbstractSourceTextAnchorAdapter adapterFor: anEntity.
	sourceAnchorAdapter initializeDisplayedText: formatedText andEntity: anEntity.

	self reRenderText

]

{ #category : 'accessing' }
MiSourceTextSpecRenderer >> rendererModel [

	^ rendererModel
]

{ #category : 'accessing' }
MiSourceTextSpecRenderer >> rendererModel: anObject [

	rendererModel := anObject.
	anObject renderer: self
]

{ #category : 'initialization' }
MiSourceTextSpecRenderer >> setModelBeforeInitialization: aModel [

	self rendererModel: aModel
]

{ #category : 'accessing' }
MiSourceTextSpecRenderer >> sourceAnchorAdapter [

	^sourceAnchorAdapter
]
