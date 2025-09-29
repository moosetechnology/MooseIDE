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

{ #category : #'api - actions' }
MiRelationQueryPresenter >> configureFor: aQuery [

	query := aQuery.
	self initializeDropListForRelations: { aQuery relationName }.
	relationsList selectItem: aQuery relationName.
	query relationName: aQuery relationName
]

{ #category : #actions }
MiRelationQueryPresenter >> configureQuery: anObject [

	self query relationName: anObject
]

{ #category : #initialization }
MiRelationQueryPresenter >> initializeDropListForRelations: relationNames [

	relationsList := relationNames
		                 ifEmpty: [ self noParameterMessage: 'relations' ]
		                 ifNotEmpty: [ 
			                 self 
				                 initializeRelationDroplistForValidQueryRelations:
				                 relationNames ]
]

{ #category : #initialization }
MiRelationQueryPresenter >> initializePresenters [

	self initializeDropListForRelations: query availableRelationNames.
	self initializeLayout
]

{ #category : #initialization }
MiRelationQueryPresenter >> initializeRelationDroplistForValidQueryRelations: relationNames [

	^ self newDropList
		  startWithoutSelection;
		  items: relationNames;
		  whenSelectedItemChangedDo: [ :selectedRelationName | 
			  self computeQueryAction: selectedRelationName ]
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
