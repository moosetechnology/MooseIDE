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
MiTaggedEntityQueryPresenter >> initializeDropListForTags: tagNames [

	tagList := tagNames
		ifEmpty: [ self noParameterMessage: 'tags' ]
		ifNotEmpty: [ 
			self initializeRelationDroplistForValidQueryTags: tagNames ]
]

{ #category : #initialization }
MiTaggedEntityQueryPresenter >> initializePresenters [

	self initializeDropListForTags: query availableTagNames.
	self initializeLayout
]

{ #category : #'api - actions' }
MiTaggedEntityQueryPresenter >> initializeRelationDroplistForValidQueryTags: tagNames [

	^ self newDropList
		  startWithoutSelection;
		  items: tagNames ;
		  whenSelectedItemChangedDo: [ :selectedTagName | 
			  self computeQueryAction: selectedTagName ]
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
