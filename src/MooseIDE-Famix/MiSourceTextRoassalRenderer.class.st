Class {
	#name : #MiSourceTextRoassalRenderer,
	#superclass : #MiAbstractVisualization,
	#instVars : [
		'model',
		'roassalTextRenderer'
	],
	#category : #'MooseIDE-Famix-SourceText'
}

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

{ #category : #accessing }
MiSourceTextRoassalRenderer >> model [
	^model
]

{ #category : #accessing }
MiSourceTextRoassalRenderer >> model: aSourceTextModel [
	model := aSourceTextModel 
]

{ #category : #initialization }
MiSourceTextRoassalRenderer >> run [
	roassalTextRenderer text: model sourceText.
	model highlights do: [ :hlght | roassalTextRenderer addAttribute: hlght toRoassal ].
	roassalTextRenderer renderIn: self canvas
]

{ #category : #accessing }
MiSourceTextRoassalRenderer >> setModelBeforeInitialization: aModel [
	model := aModel
]
