"
The page of the TagBrowser notebook showing the boolean query that allows to check whether this tag applied to an entity or not

This is the so called _Intent description_ of the tag
"
Class {
	#name : #MiTagIntentPage,
	#superclass : #MiAbstractTagNotebookPage,
	#instVars : [
		'queryList',
		'selectedQuery',
		'txtLowValue',
		'txtHighValue',
		'tagBrowser'
	],
	#category : #'MooseIDE-Tagging-Browser'
}

{ #category : #accessing }
MiTagIntentPage class >> defaultTitle [
	^'Tag Intent'
]

{ #category : #initialization }
MiTagIntentPage >> initializeLayout [
	self layout: (SpBoxLayout newTopToBottom
		add: 'Available queries' ;
		add: queryList ;
		add: 'Selected query:' ;
		add: selectedQuery ;
		add: 'For values between:' ;
		add: (SpBoxLayout newLeftToRight
			add: txtLowValue expand: false ;
			add: 'and:' ;
			add: txtHighValue expand: false ;
			yourself ) ;
		yourself)

]

{ #category : #initialization }
MiTagIntentPage >> initializePresenters [
	super initializePresenters.

	txtLowValue := self newText
		placeholder: 'Min.value';
		yourself.
	txtHighValue := self newTextInput
		placeholder: 'Max.value';
		yourself.

	queryList := self newFilteringList
		"display: [ :entity | entity name ];"
		yourself.
	self refreshQueryList.
	
	selectedQuery := self newText 
		enabled: false ;
		yourself.
		
	self initializeLayout .
]

{ #category : #refreshing }
MiTagIntentPage >> onBrowserPageRedisplay [
	"nothing to do"
]

{ #category : #initialization }
MiTagIntentPage >> refreshQueryList [
	^#()
]
