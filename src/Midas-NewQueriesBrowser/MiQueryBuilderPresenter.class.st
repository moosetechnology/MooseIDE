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

	parentBrowser updateForQuery: query.
	self updateComponentList
]

{ #category : #accessing }
MiQueryBuilderPresenter >> currentQuery [

	^ parentBrowser currentQuery
]

{ #category : #'api - actions' }
MiQueryBuilderPresenter >> followAction: newCurrentQuery [

	presenters := OrderedCollection new
		              add: newCurrentQuery;
		              yourself.
	self updateComponentList
]

{ #category : #initialization }
MiQueryBuilderPresenter >> initializeFirstQueryCreation [

	| queryCreationPresenter |
	queryCreationPresenter := self instantiate:
		                          (MiNewQueryCreationPresenter on: self).
	queryCreationPresenter removeButtonRemove.
	presenters add: queryCreationPresenter.
	self updateComponentList
]

{ #category : #initialization }
MiQueryBuilderPresenter >> initializePresenters [

	presenters := OrderedCollection new.
	componentListPresenter := self newComponentList
		                          propagateNaturalHeight: true;
		                          yourself.
	self initializeFirstQueryCreation
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
