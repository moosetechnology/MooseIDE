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
MiAbstractSourceTextAnchorAdapter class >> acceptEntity: anEntity [

	^false
]

{ #category : #'as yet unclassified' }
MiAbstractSourceTextAnchorAdapter class >> adapterFor: anEntity [

	self withAllSubclassesDo: [ :adapterClass |
		(adapterClass acceptEntity: anEntity)
			ifTrue: [ ^adapterClass new ]
	].

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

{ #category : #initialization }
MiAbstractSourceTextAnchorAdapter >> initialize [

	super initialize.

	displayedEntityInterval := nil -> nil.
	displayedText := ''
]

{ #category : #initialization }
MiAbstractSourceTextAnchorAdapter >> initializeDisplayedText: aText andEntity: anEntity [
	"initialize the adapter with the displayedText and the main displayedEntity"

	self displayedText: aText.
	displayedEntityInterval := anEntity -> (Interval from: 1 to: aText size)
]

{ #category : #api }
MiAbstractSourceTextAnchorAdapter >> intervalForEntity: anEntity [
	"Find the first and last character of anEntity's name in the displayedText"

	^(displayedEntityInterval key = anEntity)
		ifTrue: [ ^displayedEntityInterval value ]
		ifFalse: [ nil ]

]
