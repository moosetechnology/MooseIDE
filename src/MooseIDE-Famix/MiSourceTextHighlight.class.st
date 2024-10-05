"
Abstract class for all highlights that we may apply on a portion of text.

These highlights are ""conceptual"" (e.g. ErrorHighlight)
How these highlights are displayed depends on the MiSourceTextXXXRenderer

An highlight applies:
- on a #referenceSource text
- from a #highlightesEntity
- on an #interval (from/to) of this text
"
Class {
	#name : #MiSourceTextHighlight,
	#superclass : #Object,
	#instVars : [
		'highlightedEntity',
		'highlightInterval'
	],
	#category : #'MooseIDE-Famix-SourceText'
}

{ #category : #formatting }
MiSourceTextHighlight >> adaptSourceAnchorWith: aSourceAnchorAdapter [

	(aSourceAnchorAdapter intervalForEntity: self boundingEntity)
		ifNotNil: [ :entityInterval |
			self
				setIntervalIn: aSourceAnchorAdapter displayedText
				boundedBy: entityInterval
		]
]

{ #category : #formatting }
MiSourceTextHighlight >> applyTo: aRenderer [

	aRenderer applyCommentHighlight: self
]

{ #category : #formatting }
MiSourceTextHighlight >> boundingEntity [

	self subclassResponsibility 
]

{ #category : #accessing }
MiSourceTextHighlight >> from [

	^highlightInterval first
]

{ #category : #testing }
MiSourceTextHighlight >> hasInterval [

	^highlightInterval isNotNil
]

{ #category : #accessing }
MiSourceTextHighlight >> highlightInterval: anObject [

	^ highlightInterval := anObject
]

{ #category : #accessing }
MiSourceTextHighlight >> highlightedEntity [

	^ highlightedEntity
]

{ #category : #accessing }
MiSourceTextHighlight >> highlightedEntity: anObject [

	highlightedEntity := anObject
]

{ #category : #formatting }
MiSourceTextHighlight >> setIntervalIn: aText boundedBy: anInterval [

	| startOfHighlight |
	startOfHighlight := aText
		findString: self stringToHighlight
		startingAt: anInterval first.

	highlightInterval := (startOfHighlight > 0)
		ifTrue: [Interval
			from: startOfHighlight
			to: (startOfHighlight + self stringToHighlight size - 1) ]
		ifFalse: [ nil ]
]

{ #category : #formatting }
MiSourceTextHighlight >> stringToHighlight [

	self subclassResponsibility 
]

{ #category : #accessing }
MiSourceTextHighlight >> to [

	^highlightInterval last
]
