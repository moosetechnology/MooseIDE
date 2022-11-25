"
The query configuration presenter for FQTaggedEntityQuery
"
Class {
	#name : #MiTaggedEntityQueryPresenter,
	#superclass : #MiQueryConfiguratorPresenter,
	#instVars : [
		'tagList'
	],
	#category : #'MooseIDE-QueriesBrowser-Configuration presenters'
}

{ #category : #'api - actions' }
MiTaggedEntityQueryPresenter >> configureFor: aQuery [

	query := aQuery.
	self initializeDropListForTags: { aQuery tagName }.
	tagList selectItem: aQuery tagName.
	query tagName: aQuery tagName
]

{ #category : #actions }
MiTaggedEntityQueryPresenter >> configureQuery: anObject [

	self query tagName: anObject
]

{ #category : #'api - actions' }
MiTaggedEntityQueryPresenter >> initializeDropListForTags: aCollection [

	tagList := aCollection
		                 ifEmpty: [ self noParameterMessage: 'tags' ]
		                 ifNotEmpty: [ 
			                 self 
				                 initializeRelationDroplistForValidQueryTags:
				                 aCollection ]
]

{ #category : #initialization }
MiTaggedEntityQueryPresenter >> initializePresenters [

	self initializeDropListForTags: query availableTags.
	self initializeLayout
]

{ #category : #'api - actions' }
MiTaggedEntityQueryPresenter >> initializeRelationDroplistForValidQueryTags: aCollection [

	^ self newDropList
		  startWithoutSelection;
		  items: (aCollection collect: #name) ;
		  whenSelectedItemChangedDo: [ :selectedTag | 
			  self computeQueryAction: selectedTag ]
]

{ #category : #layout }
MiTaggedEntityQueryPresenter >> newLayout [

	| padding |
	padding := 5.
	^ SpBoxLayout newLeftToRight
		add: tagList
		expand: false
		fill: true
		padding: padding;
		yourself
]
