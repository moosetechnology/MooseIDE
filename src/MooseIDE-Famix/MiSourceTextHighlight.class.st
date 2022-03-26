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

{ #category : #api }
MiSourceTextHighlight >> restrictIntervalTo: aName in: aString [
	"sets the interval to the 1st line containing aName in aString"
	| myStart |
	myStart := aString
		findString: aName
		startingAt: interval first.

	self interval:
		(Interval
			from: myStart
			to: (myStart + aName size - 1))

]

{ #category : #accessing }
MiSourceTextHighlight >> to [

	^ interval last
]
