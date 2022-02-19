"
A renderer of highlighted source text using Spec SpTextPresenter.
Ideally it would be subclass of a MiSourceTextAbstractRenderer, but it also need to inherit from SpTextPresenter

A renderer has a MiSourceTextBrowserModel and a browser.
It can #renderText by applying the highlights of its #model
"
Class {
	#name : #MiSourceTextSpecRenderer,
	#superclass : #SpTextPresenter,
	#instVars : [
		'model',
		'formatedText'
	],
	#category : #'MooseIDE-Famix-SourceText'
}

{ #category : #formatting }
MiSourceTextSpecRenderer >> applyErrorHighlight: aHighlight [
	formatedText 
		addAttribute: TextColor red
		from: aHighlight from
		to: aHighlight to ;
		yourself

]

{ #category : #formatting }
MiSourceTextSpecRenderer >> applyIdentifierHighlight: aHighlight [
	formatedText 
		addAttribute: TextEmphasis underlined
		from: aHighlight from
		to: aHighlight to ;

		addAttribute: TextEmphasis italic
		from: aHighlight from
		to: aHighlight to ;

		addAttribute:
			(TextDoIt new actOnClickBlock: [ model selectedEntity: aHighlight highlightedEntity ])
		from: aHighlight from
		to: aHighlight to ;

		addAttribute: TextColor black
		from: aHighlight from
		to: aHighlight to.

]

{ #category : #formatting }
MiSourceTextSpecRenderer >> applyTagHighlight: aHighlight [
	formatedText
		addAttribute: (TextBackgroundColor color: (aHighlight highlightedEntity color))
		from: aHighlight from
		to: aHighlight to
]

{ #category : #accessing }
MiSourceTextSpecRenderer >> browser [
	^self model browser
]

{ #category : #'private - testing' }
MiSourceTextSpecRenderer >> formatedText [
	^formatedText 
]

{ #category : #initialization }
MiSourceTextSpecRenderer >> initialize [
	super initialize.
	self beEditable
]

{ #category : #accessing }
MiSourceTextSpecRenderer >> model [
	^model
]

{ #category : #accessing }
MiSourceTextSpecRenderer >> model: aSourceTextModel [
	model := aSourceTextModel
]

{ #category : #rendering }
MiSourceTextSpecRenderer >> renderText [
	formatedText := model displayedText asText.
	model highlights do: [ :hlght | hlght applyTo: self ].
	self text: formatedText

]

{ #category : #initialization }
MiSourceTextSpecRenderer >> setModelBeforeInitialization: aModel [
	self model: aModel
]
