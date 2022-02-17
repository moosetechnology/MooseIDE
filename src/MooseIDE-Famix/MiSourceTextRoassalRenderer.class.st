"
A renderer of highlighted source text using Roassal.
Ideally it would be subclass of a MiSourceTextAbstractRenderer, but it also need to inherit from MiAbstractVisualization

A renderer has a MiSourceTextBrowserModel and a browser.
It can #renderText by applying the highlights of its #model
"
Class {
	#name : #MiSourceTextRoassalRenderer,
	#superclass : #MiAbstractVisualization,
	#instVars : [
		'roassalTextRenderer',
		'model'
	],
	#category : #'MooseIDE-Famix-SourceText'
}

{ #category : #formatting }
MiSourceTextRoassalRenderer >> applyErrorHighlight: aHighlight [

]

{ #category : #formatting }
MiSourceTextRoassalRenderer >> applyIdentifierHighlight: aHighlight [
	^RSLinkEmphasisAttribute new
		from: aHighlight from ;
		to: aHighlight to ;
		on: RSMouseClick do: [ :event | self browser selected: aHighlight highlightedEntity ] ;
		yourself
]

{ #category : #formatting }
MiSourceTextRoassalRenderer >> applyTagHighlight: aHighlight [
	^RSTagEmphasisAttribute new
		from: aHighlight from ;
		to: aHighlight to ;
		color: aHighlight highlightedEntity color ; 
		on: RSMouseClick do: [ :event | self browser selected: aHighlight highlightedEntity ] ;
		yourself
]

{ #category : #accessing }
MiSourceTextRoassalRenderer >> browser [
	^model browser
]

{ #category : #highlighting }
MiSourceTextRoassalRenderer >> highlightShapes [
	^ #()
]

{ #category : #initialization }
MiSourceTextRoassalRenderer >> initialize [

	super initialize.
	self script: [ :canvas | canvas ].
	roassalTextRenderer := RSAttributedText new.
]

{ #category : #highlighting }
MiSourceTextRoassalRenderer >> renderText [
	roassalTextRenderer text: model sourceText.
	model highlights do: [ :hlght | hlght applyTo: self ].
	roassalTextRenderer renderIn: self canvas
]

{ #category : #initialization }
MiSourceTextRoassalRenderer >> setModelBeforeInitialization: aModel [
	model := aModel
]
