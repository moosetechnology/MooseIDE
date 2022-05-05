"
I am a query configuration presenter for all N-ary queries (before called binary queries but are not longer binaries because they can do with the operation with more than two queries)
"
Class {
	#name : #MiNAryQueryPresenter,
	#superclass : #MiQueryConfiguratorPresenter,
	#instVars : [
		'subqueryDropLists',
		'addSubqueryToLayoutButton',
		'removeSubqueryFromLayoutButton'
	],
	#category : #'MooseIDE-QueriesBrowser-Configuration presenters'
}

{ #category : #accessing }
MiNAryQueryPresenter class >> dropListWidth [

	^ 57
]

{ #category : #actions }
MiNAryQueryPresenter >> addSubqueryPresenter [

	subqueryDropLists add: self newSubqueryDropList
]

{ #category : #actions }
MiNAryQueryPresenter >> addSubqueryToLayoutAction [

	self addSubqueryPresenter.
	removeSubqueryFromLayoutButton enable.
	self initializeLayout
]

{ #category : #'api - actions' }
MiNAryQueryPresenter >> configureFor: aQuery [

	"We know that the NAry query has at last two subqueries"
	subqueryDropLists first selectItem:
		(owner queriesListPresenter findPresenterForQuery: aQuery subqueries first).
	subqueryDropLists second selectItem:
		(owner queriesListPresenter findPresenterForQuery: aQuery subqueries second).
	
	"Add the rest of the subqueries if they exist"
	aQuery subqueries from: 3 to: aQuery subqueries size do: [ :each |
		self addSubqueryPresenter.
		subqueryDropLists last selectItem:
			(owner queriesListPresenter findPresenterForQuery: each) ].

	query := aQuery.
	self initializeLayout

]

{ #category : #actions }
MiNAryQueryPresenter >> configureQuery: newSelectedItem [

	self nAryOperation: newSelectedItem
]

{ #category : #initialization }
MiNAryQueryPresenter >> initialize [

	super initialize.
	owner queriesListPresenter announcer
		when: QueriesListChangedAnnouncement
		do: [ self queryPresentersListChanged ]
]

{ #category : #initialization }
MiNAryQueryPresenter >> initializeButtons [

	addSubqueryToLayoutButton := self newButton.
	addSubqueryToLayoutButton
		icon: (self iconNamed: #smallAdd);
		action: [ self addSubqueryToLayoutAction ].
	removeSubqueryFromLayoutButton := self newButton.
	removeSubqueryFromLayoutButton
		icon: (self iconNamed: #smallDelete);
		action: [ self removeSubqueryFromLayoutAction ].
	"The remove button must be enabled only when there is more than 2 subqueries in the drop lists."
	removeSubqueryFromLayoutButton disable
]

{ #category : #initialization }
MiNAryQueryPresenter >> initializePresenters [

	self initializeButtons.
	subqueryDropLists := OrderedCollection withAll: { 
			                     self newSubqueryDropList.
			                     self newSubqueryDropList }.
	self initializeLayout
]

{ #category : #testing }
MiNAryQueryPresenter >> isQueryUsed: aQuery [

	^ subqueryDropLists anySatisfy: [ :dropList | 
		dropList selectedItem = aQuery ]
]

{ #category : #actions }
MiNAryQueryPresenter >> nAryOperation: newSelectedItem [

	| subqueries selectedDropListItems |
	"Sometimes the SpDropListPresenter>>#whenSelectedItemChangedDo: in spec is triggered even though no item was selected. 
	When this happends the selected item is nil. This is a spec problem."
	newSelectedItem ifNil: [ ^ self ].

	selectedDropListItems := subqueryDropLists collect: #selectedItem.

	(selectedDropListItems anySatisfy: [ :selectedQuery | 
		 selectedQuery isNil ]) ifTrue: [ ^ self ].
	
	subqueries := selectedDropListItems collect: #query.
	query
		subqueries: subqueries;
		resetResult
]

{ #category : #layout }
MiNAryQueryPresenter >> newLayout [

	| tempLayout |
	tempLayout := SpBoxLayout newLeftToRight
		              spacing: 5;
		              yourself.

	subqueryDropLists do: [ :subqueryPresenter | 
		tempLayout add: subqueryPresenter width: self class dropListWidth ].

	tempLayout
		add: addSubqueryToLayoutButton width: self class iconWidth;
		add: removeSubqueryFromLayoutButton width: self class iconWidth.

	^ tempLayout
]

{ #category : #actions }
MiNAryQueryPresenter >> newSubqueryDropList [

	| availableQueryPresentersForOperation |
	availableQueryPresentersForOperation := owner
		                                        allQueryPresentersExceptSelf.
	^ self newDropList
		  startWithoutSelection;
		  items: availableQueryPresentersForOperation;
		  display: [ :each | each name ];
		  whenSelectedItemChangedDo: [ :selectedItem | 
			  self computeQueryAction: selectedItem ];
		  yourself
]

{ #category : #'api - actions' }
MiNAryQueryPresenter >> queryPresentersListChanged [

	"Since the list of available queries of the MiQueryBuilder changed, 
		we need to update the items on the drop list. 
	We do not want to have deleted queries on the list. 
	We want to add to the list the new added query presenter. "

	| previouslySelectedQuery newAvailableQueries |
	newAvailableQueries := owner allQueryPresentersExceptSelf.

	subqueryDropLists do: [ :dropList | 
		previouslySelectedQuery := dropList selectedItem.
		(newAvailableQueries includes: previouslySelectedQuery)
			ifTrue: [ 
			dropList updateItemsKeepingSelection: newAvailableQueries ]
			ifFalse: [ dropList items: newAvailableQueries ] ]
]

{ #category : #actions }
MiNAryQueryPresenter >> removeSubqueryFromLayoutAction [

	subqueryDropLists removeLast.
	subqueryDropLists size < 3 ifTrue: [ 
		removeSubqueryFromLayoutButton disable ].
	self initializeLayout
]
