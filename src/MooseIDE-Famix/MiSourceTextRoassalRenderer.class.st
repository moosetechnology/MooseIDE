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

	roassalTextRenderer
		addAttribute: RSForgroundColorEmphasisAttribute new
		from: aHighlight from
		to: aHighlight to
]

{ #category : #formatting }
MiSourceTextRoassalRenderer >> applyIdentifierHighlight: aHighlight [

	roassalTextRenderer
		addAttribute: (RSLinkEmphasisAttribute new
				 on: RSMouseClick
				 do: [ :event |
				 model selectedEntity: aHighlight highlightedEntity ])
		from: aHighlight from
		to: aHighlight to
]

{ #category : #formatting }
MiSourceTextRoassalRenderer >> applyTagHighlight: aHighlight [

	roassalTextRenderer
		addAttribute: (RSTagEmphasisAttribute new
				 color: aHighlight highlightedEntity color;
				 on: RSMouseClick
				 do: [ :event |
					 model selectedEntity: aHighlight highlightedEntity ])
		from: aHighlight from
		to: aHighlight to
]

{ #category : #accessing }
MiSourceTextRoassalRenderer >> browser [

	^ model browser
]

{ #category : #highlighting }
MiSourceTextRoassalRenderer >> buildInCanvas: aCanvas [

	model displayedText ifNil: [ ^ self ].

	roassalTextRenderer text: model displayedText.
	model highlights do: [ :hlght | hlght applyTo: self ].
	roassalTextRenderer renderIn: aCanvas
]

{ #category : #highlighting }
MiSourceTextRoassalRenderer >> highlightShapes [
	^ #()
]

{ #category : #initialization }
MiSourceTextRoassalRenderer >> initialize [

	super initialize.

	roassalTextRenderer := RSAttributedText new.
	self script: [ :canvas | self buildInCanvas: canvas ]
]

{ #category : #highlighting }
MiSourceTextRoassalRenderer >> renderText [

	self run
]

{ #category : #'accessing - model' }
MiSourceTextRoassalRenderer >> setModelBeforeInitialization: aModel [

	model := aModel
]
