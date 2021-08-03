"
I am a query configuration presenter for all N-ary queries (before called binary queries but are not longer binaries because they can do with the operation with more than two queries)
"
Class {
	#name : #MiNAryQueryPresenter,
	#superclass : #MiQueryConfigurationPresenter,
	#instVars : [
		'subqueryDropLists',
		'addSubqueryToLayoutButton',
		'removeSubqueryFromLayoutButton'
	],
	#category : #'MooseIDE-NewTools-Queries Browser configuration'
}

{ #category : #accessing }
MiNAryQueryPresenter class >> dropListWidth [

	^ 57
]

{ #category : #actions }
MiNAryQueryPresenter >> addSubqueryToLayout [

	subqueryDropLists add: self newSubqueryDropList.
	removeSubqueryFromLayoutButton enable.
	self buildLayout.
	self update
]

{ #category : #actions }
MiNAryQueryPresenter >> availableQueryPresentersFromOwner [

	^ owner allQueryPresenters reject: [ :q | q query = self owner query ]
]

{ #category : #layout }
MiNAryQueryPresenter >> buildLayout [

	| tempLayout |
	tempLayout := SpBoxLayout newLeftToRight
		              spacing: 5;
		              yourself.
	subqueryDropLists do: [ :subqueryPresenter | 
		tempLayout add: subqueryPresenter width: self class dropListWidth ].
	tempLayout
		add: #addSubqueryToLayoutButton width: self class iconWidth;
		add: #removeSubqueryFromLayoutButton width: self class iconWidth.
	self layout: tempLayout
]

{ #category : #actions }
MiNAryQueryPresenter >> computeQuery: newSelectedItem [

	self nAryOperation: newSelectedItem
]

{ #category : #initialization }
MiNAryQueryPresenter >> initializeButtons [

	addSubqueryToLayoutButton := self newButton.
	addSubqueryToLayoutButton
		icon: (self iconNamed: #smallAdd);
		action: [ self addSubqueryToLayout ].
	removeSubqueryFromLayoutButton := self newButton.
	removeSubqueryFromLayoutButton
		icon: (self iconNamed: #smallDelete);
		action: [ self removeSubqueryFromLayout ].
	"The remove button must be enabled only when there is more than 2 subqueries in the drop lists."
	removeSubqueryFromLayoutButton disable
]

{ #category : #initialization }
MiNAryQueryPresenter >> initializePresenters [

	self initializeButtons.
	subqueryDropLists := OrderedCollection withAll: { 
			                     self newSubqueryDropList.
			                     self newSubqueryDropList }
]

{ #category : #actions }
MiNAryQueryPresenter >> nAryOperation: newSelectedItem [

	| subqueries selectedDropListItems |
	"Sometimes the SpDropListPresenter>>#whenSelectedItemChangedDo: in spec is triggered even though no item were selected. When this happends the selected item is nil. This is an spec problem."
	newSelectedItem ifNil: [ ^ self ].
	(subqueryDropLists anySatisfy: [ :dropList | 
		 dropList selectedItem isNil ]) ifTrue: [ ^ self ].

	selectedDropListItems := subqueryDropLists collect: #selectedItem.
	subqueries := selectedDropListItems collect: #query.
	query
		subqueries: subqueries;
		resetResult
]

{ #category : #actions }
MiNAryQueryPresenter >> newSubqueryDropList [

	| availableQueryPresentersForOperation |
	availableQueryPresentersForOperation := self
		                                        availableQueryPresentersFromOwner.
	^ self newDropList
		  items: availableQueryPresentersForOperation;
		  display: [ :each | each name ];
		  whenSelectedItemChangedDo: [ :selectedItem | 
			  self computeQueryAction: selectedItem ];
		  yourself
]

{ #category : #'api - actions' }
MiNAryQueryPresenter >> queryPresentersListChanged [

	"Since the list of available queries of the MiQueryBuilder changed, we need to update the items on the drop list. We do not want to have deleted queries on the list. We want to add to the list the new added query presenter. "

	| previouslySelectedQuery newAvailableQueries |
	newAvailableQueries := self availableQueryPresentersFromOwner.
	subqueryDropLists do: [ :dropList | 
		previouslySelectedQuery := dropList selectedItem.
		(newAvailableQueries includes: previouslySelectedQuery)
			ifTrue: [ 
			dropList updateItemsKeepingSelection: newAvailableQueries ]
			ifFalse: [ dropList items: newAvailableQueries ] ]
]

{ #category : #actions }
MiNAryQueryPresenter >> removeSubqueryFromLayout [

	subqueryDropLists removeLast.
	subqueryDropLists size < 3 ifTrue: [ removeSubqueryFromLayoutButton disable ].
	self buildLayout.
	self update
]
