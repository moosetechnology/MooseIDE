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

{ #category : #adding }
MiQueryBuilderPresenter >> addChildToQuery: query [

	parentBrowser addChildToQuery: query
]

{ #category : #'accessing model' }
MiQueryBuilderPresenter >> currentQuery [

	^ parentBrowser currentQuery
]

{ #category : #initialization }
MiQueryBuilderPresenter >> initializeFirstQueryCreation [

	| queryCreationPresenter |
	queryCreationPresenter := self instantiate:
		                          (MiNewQueryCreationPresenter on: self).
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

{ #category : #'accessing model' }
MiQueryBuilderPresenter >> setModelBeforeInitialization: aQueryBrowserPresenter [

	parentBrowser := aQueryBrowserPresenter
]

{ #category : #initialization }
MiQueryBuilderPresenter >> updateComponentList [

	componentListPresenter presenters: presenters
]

{ #category : #'as yet unclassified' }
MiQueryBuilderPresenter >> updateQueryBrowserCodePresenter: query [

	parentBrowser queryCodePresenter updateForQuery: query
	"syntaxHighlight: self query isValid;"
]

{ #category : #api }
MiQueryBuilderPresenter >> updateQueryBrowserResultListEntities: resultQueryEntities [

	parentBrowser queryResultTreePresenter updateForEntities:
		resultQueryEntities
]
