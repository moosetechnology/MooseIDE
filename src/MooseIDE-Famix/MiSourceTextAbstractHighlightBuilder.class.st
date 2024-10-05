Class {
	#name : #MiSourceTextAbstractHighlightBuilder,
	#superclass : #Object,
	#instVars : [
		'model'
	],
	#category : #'MooseIDE-Famix-SourceText'
}

{ #category : #highlights }
MiSourceTextAbstractHighlightBuilder >> commentHighlightFor: aComment [

	model addHighlight: (MiSourceTextCommentHighlight new
		highlightedEntity: aComment ;
		yourself)

]

{ #category : #highlights }
MiSourceTextAbstractHighlightBuilder >> createHighlightsFor: anEntity [

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

	"aChildEntity queryAllOutgoing do: [:mseAssoc |
		mseAssoc allTargets do: [ :target | 	self addHighlight: (self dependencyHighlightFor: mseAssoc) ]
	]."
]

{ #category : #highlights }
MiSourceTextAbstractHighlightBuilder >> errorHighlightInterval: anInterval [

	model addHighlight: (MiSourceTextErrorHighlight new
		highlightInterval: anInterval ;
		yourself)

]

{ #category : #highlights }
MiSourceTextAbstractHighlightBuilder >> identifierHighlightFor: aChildEntity [
	
	model addHighlight: (MiSourceTextIdentifierHighlight new
		highlightedEntity: aChildEntity ;
		yourself)

]

{ #category : #accessing }
MiSourceTextAbstractHighlightBuilder >> model [

	^ model
]

{ #category : #accessing }
MiSourceTextAbstractHighlightBuilder >> model: anObject [

	model := anObject
]

{ #category : #highlights }
MiSourceTextAbstractHighlightBuilder >> nullHighlightFor: aChildEntity [

]

{ #category : #highlights }
MiSourceTextAbstractHighlightBuilder >> tagHighlightFor: anEntity [

	model addHighlight: (MiSourceTextTagHighlight new
		highlightedEntity: anEntity ;
		yourself)

]
