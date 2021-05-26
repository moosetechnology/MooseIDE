"
I contain a presenter collection. Each of the elements of that collection is a query creation presenter. When the add button is pressed, a presenter is added to the collection. Same for the remove button.
Also I have a componentListPresenter instance variable. The elements of this list are the same as the elements of the presenters collection.
Each query is an instance of `MiNewQueryCreationPresenter`.

I manage all the logic related to showing all the queries. Also, I update myself and my parentBrowser when a query is added or removed.
"
Class {
	#name : #MiQueryBuilderPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'presenters',
		'parentBrowser',
		'componentListPresenter'
	],
	#category : #'Midas-NewTools-Queries Browser'
}

{ #category : #'api - actions' }
MiQueryBuilderPresenter >> addNewQueryAction: query [

	| newPresenter |
	newPresenter := self instantiate:
		                ((MiNewQueryCreationPresenter on: query) 
			                 parentPresenter: self).
	presenters add: newPresenter.

	parentBrowser addNewQuery: query.
	self updateComponentList
]

{ #category : #actions }
MiQueryBuilderPresenter >> createFirstQueryForComponentList [

	| queryCreationPresenter |
	queryCreationPresenter := self instantiate:
		                          ((MiNewQueryCreationPresenter on:
			                            parentBrowser rootQuery) 
			                           parentPresenter: self).
	queryCreationPresenter removeButtonRemove.
	presenters := OrderedCollection with: queryCreationPresenter.
	self updateComponentList
]

{ #category : #'api - actions' }
MiQueryBuilderPresenter >> followAction [

	"Re instantiate the first query"

	self createFirstQueryForComponentList
]

{ #category : #initialization }
MiQueryBuilderPresenter >> initializeLayout [

	self layout: (SpBoxLayout newTopToBottom
			 add: #componentListPresenter;
			 yourself)
]

{ #category : #initialization }
MiQueryBuilderPresenter >> initializePresenters [

	self initializeLayout.
	presenters := OrderedCollection empty.
	componentListPresenter := self newComponentList.
	componentListPresenter
		activateOnSingleClick;
		propagateNaturalHeight: true;
		whenSelectedDo: [ :selectedPresenter | 
			parentBrowser selectQuery: selectedPresenter query ].
	self createFirstQueryForComponentList
]

{ #category : #'api - actions' }
MiQueryBuilderPresenter >> queryChangedUpdate: query [

	parentBrowser queryChangedUpdate: query
]

{ #category : #actions }
MiQueryBuilderPresenter >> removePresentersAssociatedWith: nodeQuery [

	nodeQuery children do: [ :childQuery | 
		| presenterToRemove |
		presenterToRemove := presenters detect: [ :aPresenter | 
			                     aPresenter query = childQuery ].
		presenters remove: presenterToRemove.
		self removePresentersAssociatedWith: childQuery ]
]

{ #category : #'api - actions' }
MiQueryBuilderPresenter >> removeQueryAction: aQueryCreationPresenter [

	parentBrowser removeQuery: aQueryCreationPresenter query.
	presenters remove: aQueryCreationPresenter.
	self removePresentersAssociatedWith: aQueryCreationPresenter query.
	"presenters last enable."
	self updateComponentList
]

{ #category : #'accessing model' }
MiQueryBuilderPresenter >> setModelBeforeInitialization: aQueryBrowserPresenter [

	parentBrowser := aQueryBrowserPresenter
]

{ #category : #update }
MiQueryBuilderPresenter >> updateComponentList [

	componentListPresenter presenters: presenters
]
