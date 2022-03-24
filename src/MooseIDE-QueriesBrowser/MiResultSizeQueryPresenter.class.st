"
The query configuration presenter for `FQResultSizeQuery`
"
Class {
	#name : #MiResultSizeQueryPresenter,
	#superclass : #MiQueryConfiguratorPresenter,
	#instVars : [
		'subqueriesDropList',
		'comparatorDropList',
		'valueInputField',
		'process',
		'delayer'
	],
	#category : #'MooseIDE-QueriesBrowser-Configuration presenters'
}

{ #category : #accessing }
MiResultSizeQueryPresenter class >> dropListWidth [

	^ 57
]

{ #category : #actions }
MiResultSizeQueryPresenter >> computeQuery: num [

	self query valueToCompare: num
]

{ #category : #'api - actions' }
MiResultSizeQueryPresenter >> configureFor: aQuery [

	comparatorDropList selectItem: aQuery comparator.
	valueInputField number: aQuery valueToCompare.
	subqueriesDropList selectItem:
		(owner queriesListPresenter findPresenterForQuery: aQuery innerQuery).
	query := aQuery
]

{ #category : #initialization }
MiResultSizeQueryPresenter >> initialize [

	super initialize.
	delayer := InputProcessingWaiter new.
	owner queriesListPresenter announcer
		when: QueriesListChangedAnnouncement
		do: [ self queryPresentersListChanged ]
]

{ #category : #initialization }
MiResultSizeQueryPresenter >> initializeComparatorsDropList [

	comparatorDropList := self newDropList.
	comparatorDropList
		startWithoutSelection;
		items: FQNumericQuery comparators;
		display: [ :comparator | comparator asString ];
		whenSelectedItemChangedDo: [ :comparator | 
			query comparator: comparator ]
]

{ #category : #initialization }
MiResultSizeQueryPresenter >> initializePresenters [

	self initializeSubqueriesDropList.
	self initializeComparatorsDropList.
	self initializeValueInput.
	self initializeLayout
]

{ #category : #initialization }
MiResultSizeQueryPresenter >> initializeSubqueriesDropList [

	subqueriesDropList := self newDropList.
	subqueriesDropList
		startWithoutSelection;
		items: owner allQueryPresentersExceptSelf;
		display: [ :each | each name ];
		whenSelectedItemChangedDo: [ :subQueryPresenter | 
			subQueryPresenter ifNotNil: [ 
					self query innerQuery: subQueryPresenter query ] ];
		help: 'The inner query can only be Scope or Navigation query'
]

{ #category : #initialization }
MiResultSizeQueryPresenter >> initializeValueInput [

	valueInputField := self newNumberInput.
	valueInputField
		placeholder: 'Value';
		whenNumberChangedDo: [ :newNumber | 
			delayer waitAndRun: [ self computeQueryAction: newNumber ] ]
]

{ #category : #testing }
MiResultSizeQueryPresenter >> isQueryUsed: aQuery [

	^ subqueriesDropList selectedItem = aQuery
]

{ #category : #layout }
MiResultSizeQueryPresenter >> newLayout [

	^ SpBoxLayout newLeftToRight
		  add: #subqueriesDropList width: self class dropListWidth;
		  add: #comparatorDropList width: 63;
		  add: #valueInputField width: 70;
		  yourself
]

{ #category : #'api - actions' }
MiResultSizeQueryPresenter >> queryPresentersListChanged [

	"Since the list of available queries of the MiQueryBuilder changed, we need to update the items on the drop list. We do not want to have deleted queries on the list or we want to add the new added query presenter."

	| newAvailableQueries previouslySelectedQuery |
	newAvailableQueries := owner allQueryPresentersExceptSelf.
	previouslySelectedQuery := subqueriesDropList selectedItem.
	(newAvailableQueries includes: previouslySelectedQuery)
		ifTrue: [ subqueriesDropList updateItemsKeepingSelection: newAvailableQueries ]
		ifFalse: [ subqueriesDropList items: newAvailableQueries ]
]
