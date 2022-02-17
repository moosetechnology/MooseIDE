Class {
	#name : #MiSourceTextHighlight,
	#superclass : #Object,
	#instVars : [
		'referenceSource',
		'interval',
		'highlightedEntity'
	],
	#category : #'MooseIDE-Famix-SourceText'
}

{ #category : #formatting }
MiSourceTextHighlight >> applyTo: aRenderer [
	self subclassResponsibility 
]

{ #category : #accessing }
MiSourceTextHighlight >> from [

	^ interval first
]

{ #category : #accessing }
MiSourceTextHighlight >> highlightedEntity [

	^ highlightedEntity
]

{ #category : #accessing }
MiSourceTextHighlight >> highlightedEntity: anObject [

	highlightedEntity := anObject
]

{ #category : #accessing }
MiSourceTextHighlight >> interval [

	^ interval
]

{ #category : #accessing }
MiSourceTextHighlight >> interval: anObject [

	interval := anObject
]

{ #category : #formatting }
MiSourceTextHighlight >> rawText [
	^self referenceText copyFrom: self from to: self to
]

{ #category : #accessing }
MiSourceTextHighlight >> referenceEntity [
	^self referenceSource referenceEntity
]

{ #category : #accessing }
MiSourceTextHighlight >> referenceSource [

	^ referenceSource
]

{ #category : #accessing }
MiSourceTextHighlight >> referenceSource: anObject [

	referenceSource := anObject.
	referenceSource addHighlight: self
]

{ #category : #accessing }
MiSourceTextHighlight >> referenceText [
	^self referenceSource referenceText
]

{ #category : #accessing }
MiSourceTextHighlight >> to [

	^ interval last
]
