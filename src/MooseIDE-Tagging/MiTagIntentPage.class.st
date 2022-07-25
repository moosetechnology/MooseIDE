"
The page of the TagBrowser notebook showing the boolean query that allows to check whether this tag applied to an entity or not

This is the so called _Intent description_ of the tag
"
Class {
	#name : #MiTagIntentPage,
	#superclass : #MiTagPage,
	#instVars : [
		'selectedObject'
	],
	#category : #'MooseIDE-Tagging-Browser'
}

{ #category : #initialization }
MiTagIntentPage >> initializeLayout [

	super initializeLayout.
	self layout add: selectedObject expand: false
]

{ #category : #initialization }
MiTagIntentPage >> initializePresenters [

	super initializePresenters.
	selectedObject := self newLabel.
	self initializeLayout
]

{ #category : #accessing }
MiTagIntentPage >> refresh [

	super refresh.
	selectedObject label: self model currentTag label.
	self update
]

{ #category : #initialization }
MiTagIntentPage >> refreshQueryList [
	^#()
]

{ #category : #initialization }
MiTagIntentPage >> setTag: aTag [

	super setTag: aTag.
	selectedObject label: aTag label
]
