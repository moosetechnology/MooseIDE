"
The page of the TagBrowser notebook showing the boolean query that allows to check whether this tag applied to an entity or not

This is the so called _Intent description_ of the tag
"
Class {
	#name : #MiTagIntentPage,
	#superclass : #MiTagPage,
	#instVars : [
		'selectedQuery',
		'txtLowValue',
		'txtHighValue'
	],
	#category : #'MooseIDE-Tagging-Browser'
}

{ #category : #initialization }
MiTagIntentPage >> initializeLayout [

	super initializeLayout.
	self layout add: selectedQuery expand: false
]

{ #category : #initialization }
MiTagIntentPage >> initializePresenters [

	super initializePresenters.
	selectedQuery := self newLabel.
	self initializeLayout
]

{ #category : #accessing }
MiTagIntentPage >> refresh [

	super refresh.
	selectedQuery label: (String streamContents: [ :aStream | 
			 tagModel currentTag query storeWithParentsOn: aStream ]).
	self update
]

{ #category : #initialization }
MiTagIntentPage >> refreshQueryList [
	^#()
]

{ #category : #initialization }
MiTagIntentPage >> setTag: aTag [

	super setTag: aTag.
	selectedQuery label: (String streamContents: [ :aStream | 
			 aTag query storeWithParentsOn: aStream ])
]
