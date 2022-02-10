"
The page of the TagBrowser notebook showing the boolean query that allows to check whether this tag applied to an entity or not

This is the so called _Intent description_ of the tag
"
Class {
	#name : #MiTagIntentPage,
	#superclass : #MiTagPage,
	#instVars : [
		'queryList',
		'selectedQuery',
		'txtLowValue',
		'txtHighValue'
	],
	#category : #'MooseIDE-Tagging-Browser'
}

{ #category : #initialization }
MiTagIntentPage >> initialize [

	super initialize.
	application registerConsumer: self for: FQAbstractQuery
]

{ #category : #initialization }
MiTagIntentPage >> initializeLayout [

	super initializeLayout.
	self layout add: queryList expand: false
]

{ #category : #initialization }
MiTagIntentPage >> initializePresenters [

	super initializePresenters.

	self initializeLayout
]

{ #category : #accessing }
MiTagIntentPage >> refresh [

	
]

{ #category : #initialization }
MiTagIntentPage >> refreshQueryList [
	^#()
]
