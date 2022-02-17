Class {
	#name : #MiSourceTextSpecRenderer,
	#superclass : #SpTextPresenter,
	#instVars : [
		'model'
	],
	#category : #'MooseIDE-Famix-SourceText'
}

{ #category : #formatting }
MiSourceTextSpecRenderer >> applyIdentifierHighlight: aHighlight [
	self text 
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
	self text
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
	| tmp |
	self text: model sourceText.
	tmp := self text.
	model highlights do: [ :hlght | hlght applyTo: self ].
	self text: tmp

]

{ #category : #initialization }
MiSourceTextSpecRenderer >> setModelBeforeInitialization: aModel [
	self model: aModel
]
