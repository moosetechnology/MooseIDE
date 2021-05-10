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
	#category : #'Midas-NewQueriesBrowser-Sub presenters'
}

{ #category : #specs }
MiQueryBuilderPresenter class >> defaultSpec [

	^ SpBoxLayout newTopToBottom
		  add: #componentListPresenter;
		  yourself
]

{ #category : #api }
MiQueryBuilderPresenter >> addNewQueryAction: query [

	| newPresenter |
	newPresenter := self instantiate:
		                (MiNewQueryCreationPresenter on: self).
	presenters add: newPresenter.

	parentBrowser addNewQuery: query.
	self updateComponentList
]

{ #category : #initialization }
MiQueryBuilderPresenter >> createFirstQueryForComponentList [

	| queryCreationPresenter |
	queryCreationPresenter := self instantiate:
		                          (MiNewQueryCreationPresenter on: self).
	queryCreationPresenter removeButtonRemove.
	presenters := OrderedCollection with: queryCreationPresenter.
	self updateComponentList
]

{ #category : #accessing }
MiQueryBuilderPresenter >> currentQuery [

	^ parentBrowser currentQuery
]

{ #category : #'api - actions' }
MiQueryBuilderPresenter >> followAction: newFQQuery [

	"Re initialize the component list"

	self createFirstQueryForComponentList
]

{ #category : #initialization }
MiQueryBuilderPresenter >> initializePresenters [

	presenters := OrderedCollection new.
	componentListPresenter := self newComponentList
		                          propagateNaturalHeight: true;
		                          yourself.
	self createFirstQueryForComponentList
]

{ #category : #api }
MiQueryBuilderPresenter >> queryChangedUpdate: query [

	parentBrowser queryChangedUpdate: query
]

{ #category : #api }
MiQueryBuilderPresenter >> removeQueryAction: aQuery [

	parentBrowser removeQuery: aQuery.
	presenters removeLast.
	presenters last enable.
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
