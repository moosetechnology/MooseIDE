"
This is the negation query. It receives one query and negates it. Obviously, can only negate queries that can be negated.
"
Class {
	#name : #MiNegationQueryPresenter,
	#superclass : #MiQueryConfigurationPresenter,
	#instVars : [
		'subqueryDropListPresenter'
	],
	#category : #'MooseIDE-NewTools-Queries Browser configuration'
}

{ #category : #accessing }
MiNegationQueryPresenter class >> dropListWidth [

	^ 57
]

{ #category : #initialization }
MiNegationQueryPresenter >> availableQueryPresentersFromOwner [

	^ owner allQueryPresenters reject: [ :q | q query = self owner query ]
]

{ #category : #layout }
MiNegationQueryPresenter >> buildLayout [

	self layout: (SpBoxLayout newLeftToRight
			 add: #subqueryDropListPresenter width: self class dropListWidth;
			 yourself)
]

{ #category : #actions }
MiNegationQueryPresenter >> computeQuery: selectedPresenter [

	self negateQueryAction: selectedPresenter
]

{ #category : #initialization }
MiNegationQueryPresenter >> initializePresenters [

	self initializeQueryDropListPresenter
]

{ #category : #initialization }
MiNegationQueryPresenter >> initializeQueryDropListPresenter [

	subqueryDropListPresenter := self newDropList.
	subqueryDropListPresenter
		items: self availableQueryPresentersFromOwner;
		display: [ :each | each name ];
		whenSelectedItemChangedDo: [ :item | self computeQueryAction: item ]
]

{ #category : #actions }
MiNegationQueryPresenter >> negateQueryAction: selectedPresenter [

	"Sometimes the SpDropListPresenter>>#whenSelectedItemChangedDo: in spec is triggered even though no item were selected. When this happends the selected item is nil. So to avoid crashin we check in an if that the item is not nil. This is an spec problem."

	selectedPresenter ifNil: [ ^ self ].

	query := FQComplementQuery queryToNegate: selectedPresenter query.
	query runOn: selectedPresenter query parent result
]

{ #category : #'api - actions' }
MiNegationQueryPresenter >> queryPresentersListChanged [

	"Since the list of available queries of the MiQueryBuilder changed, we need to update the items on the drop list. We do not want to have deleted queries on the list or we want to add the new added query presenter."

	| newAvailableQueries previouslySelectedQuery |
	newAvailableQueries := self availableQueryPresentersFromOwner.
	previouslySelectedQuery := subqueryDropListPresenter selectedItem.
	(newAvailableQueries includes: previouslySelectedQuery)
		ifTrue: [ 
			subqueryDropListPresenter updateItemsKeepingSelection:
				newAvailableQueries ]
		ifFalse: [ subqueryDropListPresenter items: newAvailableQueries ]
]
