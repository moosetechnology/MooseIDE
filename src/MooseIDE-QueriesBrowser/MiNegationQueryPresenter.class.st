"
This is the negation query. It receives one query and negates it. Obviously, can only negate queries that can be negated.
"
Class {
	#name : #MiNegationQueryPresenter,
	#superclass : #MiQueryConfiguratorPresenter,
	#instVars : [
		'subqueryDropListPresenter'
	],
	#category : #'MooseIDE-QueriesBrowser-Configuration presenters'
}

{ #category : #accessing }
MiNegationQueryPresenter class >> dropListWidth [

	^ 57
]

{ #category : #actions }
MiNegationQueryPresenter >> computeQuery: selectedPresenter [

	"Sometimes the SpDropListPresenter>>#whenSelectedItemChangedDo: in spec is triggered even though no item were selected. When this happends the selected item is nil. So to avoid crashin we check in an if that the item is not nil. This is an spec problem."

	selectedPresenter ifNil: [ ^ self ].

	query := FQComplementQuery queryToNegate: selectedPresenter query.
	query runOn: selectedPresenter query parent result
]

{ #category : #'api - actions' }
MiNegationQueryPresenter >> configureFor: aQuery [

	subqueryDropListPresenter selectItem:
		(owner queriesListPresenter findPresenterForQuery: aQuery queryToNegate).
	query := aQuery
]

{ #category : #initialization }
MiNegationQueryPresenter >> initialize [

	super initialize.
	owner queriesListPresenter announcer
		when: QueriesListChangedAnnouncement
		do: [ self queryPresentersListChanged ]
]

{ #category : #initialization }
MiNegationQueryPresenter >> initializePresenters [

	self initializeQueryDropListPresenter.
	self initializeLayout
]

{ #category : #initialization }
MiNegationQueryPresenter >> initializeQueryDropListPresenter [

	subqueryDropListPresenter := self newDropList.
	subqueryDropListPresenter
		startWithoutSelection;
		items: owner allQueryPresentersExceptSelf;
		display: [ :each | each name ];
		whenSelectedItemChangedDo: [ :item | self computeQueryAction: item ]
]

{ #category : #testing }
MiNegationQueryPresenter >> isQueryUsed: aQuery [

	^ subqueryDropListPresenter selectedItem = aQuery
]

{ #category : #layout }
MiNegationQueryPresenter >> newLayout [

	^ SpBoxLayout newLeftToRight
		  add: #subqueryDropListPresenter width: self class dropListWidth;
		  yourself
]

{ #category : #'api - actions' }
MiNegationQueryPresenter >> queryPresentersListChanged [

	"Since the list of available queries of the MiQueryBuilder changed, we need to update the items on the drop list. We do not want to have deleted queries on the list or we want to add the new added query presenter."

	| newAvailableQueries previouslySelectedQuery |
	newAvailableQueries := owner allQueryPresentersExceptSelf.
	previouslySelectedQuery := subqueryDropListPresenter selectedItem.
	(newAvailableQueries includes: previouslySelectedQuery)
		ifTrue: [ subqueryDropListPresenter updateItemsKeepingSelection: newAvailableQueries ]
		ifFalse: [ subqueryDropListPresenter items: newAvailableQueries ]
]
