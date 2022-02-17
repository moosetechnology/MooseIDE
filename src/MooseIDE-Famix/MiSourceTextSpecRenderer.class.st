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
		'formatingText'
	],
	#category : #'MooseIDE-Famix-SourceText'
}

{ #category : #formatting }
MiSourceTextSpecRenderer >> applyErrorHighlight: aHighlight [
	formatingText 
		addAttribute: TextColor red
		from: aHighlight from
		to: aHighlight to ;
		yourself

]

{ #category : #formatting }
MiSourceTextSpecRenderer >> applyIdentifierHighlight: aHighlight [
	formatingText 
		addAttribute: TextEmphasis underlined
		from: aHighlight from
		to: aHighlight to ;

		addAttribute: TextEmphasis italic
		from: aHighlight from
		to: aHighlight to ;

		addAttribute:
			(TextDoIt new actOnClickBlock: [ self browser selected: aHighlight highlightedEntity ])
		from: aHighlight from
		to: aHighlight to ;

		addAttribute: TextColor black
		from: aHighlight from
		to: aHighlight to.

]

{ #category : #formatting }
MiSourceTextSpecRenderer >> applyTagHighlight: aHighlight [
	formatingText
		addAttribute: (TextBackgroundColor color: (aHighlight highlightedEntity color))
		from: aHighlight from
		to: aHighlight to
]

{ #category : #accessing }
MiSourceTextSpecRenderer >> browser [
	^self model browser
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
	formatingText := model sourceText.
	model highlights do: [ :hlght | hlght applyTo: self ].
	self text: formatingText

]

{ #category : #initialization }
MiSourceTextSpecRenderer >> setModelBeforeInitialization: aModel [
	self model: aModel
]
