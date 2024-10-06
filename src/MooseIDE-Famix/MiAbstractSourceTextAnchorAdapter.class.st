"
Abstract class for SourceAnchor adapters

Its role is to find an entity's name first and last character in the `#displayedText`.
This will often rely on sourceAnchor of the entity


"
Class {
	#name : #MiAbstractSourceTextAnchorAdapter,
	#superclass : #Object,
	#instVars : [
		'displayedText',
		'displayedEntityInterval'
	],
	#category : #'MooseIDE-Famix-SourceText'
}

{ #category : #'as yet unclassified' }
MiAbstractSourceTextAnchorAdapter class >> acceptedEntities [

	^#()
]

{ #category : #'as yet unclassified' }
MiAbstractSourceTextAnchorAdapter class >> adapterFor: anEntity [

	self withAllSubclassesDo: [ :adapterClass |
		(adapterClass acceptedEntities includes: anEntity class)
			ifTrue: [ ^adapterClass new ]
	].

	Error signal: 'No SourceTextAnchorAdapter found for ' , anEntity class name.
	^MiSourceTextNullAdapter new
]

{ #category : #accessing }
MiAbstractSourceTextAnchorAdapter >> displayedText [

	^ displayedText
]

{ #category : #accessing }
MiAbstractSourceTextAnchorAdapter >> displayedText: anObject [

	displayedText := anObject
]

{ #category : #accessing }
MiAbstractSourceTextAnchorAdapter >> displayedText: aText for: anEntity [

	self displayedText: aText.

	displayedEntityInterval := anEntity -> (Interval from: 1 to: aText size)
]

{ #category : #initialization }
MiAbstractSourceTextAnchorAdapter >> initialize [

	super initialize.

	displayedEntityInterval := nil -> nil.
	displayedText := ''
]

{ #category : #api }
MiAbstractSourceTextAnchorAdapter >> intervalForEntity: anEntity [
	"Find the first and last character of anEntity's name in the displayedText
	 Here we only take care of the interval for the displayed entity
	 For others (its children), this is subclass dependent"

	^(displayedEntityInterval key = anEntity)
		ifTrue: [ ^displayedEntityInterval value ]
		ifFalse: [ nil ]

]
