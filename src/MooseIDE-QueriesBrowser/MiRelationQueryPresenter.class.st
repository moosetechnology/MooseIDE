"
The query configuration presenter for `FQRelationQuery`
"
Class {
	#name : #MiRelationQueryPresenter,
	#superclass : #MiQueryConfiguratorPresenter,
	#instVars : [
		'relationsList'
	],
	#category : #'MooseIDE-QueriesBrowser-Configuration presenters'
}

{ #category : #accessing }
MiRelationQueryPresenter class >> title [

	^ 'Relation Query'
]

{ #category : #actions }
MiRelationQueryPresenter >> computeQuery: anObject [

	self query relationName: anObject
]

{ #category : #'api - actions' }
MiRelationQueryPresenter >> configureFor: aQuery [

	relationsList selectItem: aQuery relationName.
	query relationName: aQuery relationName.
	query := aQuery
]

{ #category : #initialization }
MiRelationQueryPresenter >> initializePresenters [

	self initializeRelationsDropList.
	self initializeLayout
]

{ #category : #initialization }
MiRelationQueryPresenter >> initializeRelationsDropList [

	relationsList := self query availableRelationNames
		                 ifEmpty: [ 
		                 self noParameterMessage: 'No relations available' ]
		                 ifNotEmpty: [ :relationNames | 
			                 self newDropList
				                 startWithoutSelection;
				                 items: relationNames;
				                 whenSelectedItemChangedDo: [ 
					                 :selectedRelationName | 
					                 self computeQueryAction: selectedRelationName ] ]
]

{ #category : #layout }
MiRelationQueryPresenter >> newLayout [

	| padding |
	padding := 5.
	^ SpBoxLayout newLeftToRight
		add: relationsList
		expand: false
		fill: true
		padding: padding;
		yourself
]
