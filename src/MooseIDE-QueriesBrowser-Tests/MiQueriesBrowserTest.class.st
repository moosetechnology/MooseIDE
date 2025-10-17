"
A MiNewQueriesBrowserTest is a test class for testing the behavior of MiNewQueriesBrowser
"
Class {
	#name : 'MiQueriesBrowserTest',
	#superclass : 'MiAbstractBrowserTest',
	#instVars : [
		'helper'
	],
	#category : 'MooseIDE-QueriesBrowser-Tests-Queries Browser',
	#package : 'MooseIDE-QueriesBrowser-Tests',
	#tag : 'Queries Browser'
}

{ #category : 'running' }
MiQueriesBrowserTest >> browserClass [

	^ MiQueriesBrowser
]

{ #category : 'as yet unclassified' }
MiQueriesBrowserTest >> queriesListPresenter [

	^ browser presenterAt: #queriesListPresenter
]

{ #category : 'as yet unclassified' }
MiQueriesBrowserTest >> queryCodePresenter [

	^ browser presenterAt: #queryCodePresenter
]

{ #category : 'tests' }
MiQueriesBrowserTest >> queryResultTreeItems [

	| resultTree |
	resultTree := self queryResultTreePresenter.
	^ resultTree roots flatCollect: [ :root |
		  resultTree childrenFor: root ]
]

{ #category : 'as yet unclassified' }
MiQueriesBrowserTest >> queryResultTreePresenter [

	^ browser presenterAt: #queryResultTreePresenter
]

{ #category : 'tests' }
MiQueriesBrowserTest >> resetBrowser [

	browser withWindowDo: [ :window | window close ].
	browser := self browserClass openForTests: self application
]

{ #category : 'running' }
MiQueriesBrowserTest >> setUp [

	super setUp.
	helper := FQTestsHelper new.
	browser receiveEntity: helper classesAndMethods
]

{ #category : 'tests' }
MiQueriesBrowserTest >> testActivateActionButtons [

	self resetBrowser.

	browser actionButtons do: [ :button | self deny: button isEnabled ].

	self receiveEntityToSelect.

	browser actionButtons do: [ :button | self assert: button isEnabled ]
]

{ #category : 'tests' }
MiQueriesBrowserTest >> testAddNewNAryQuery [

	| unionQuery |
	unionQuery := self unionQuery.

	browser rootQuery addChild: unionQuery.
	browser selectQuery: unionQuery.

	self
		assertCollection: self queryResultTreeItems
		hasSameElements: unionQuery result
]

{ #category : 'tests' }
MiQueriesBrowserTest >> testCanTagEntities [
	self deny: browser canTagEntities 
]

{ #category : 'tests' }
MiQueriesBrowserTest >> testClearQueries [

	| query query2 |
	query := FQBooleanQuery new property: #isAbstract.
	query beChildOf: browser rootQuery.
	query2 := FQBooleanQuery new property: #isStub.
	query2 beChildOf: query.

	self assert: (application availableQueries includes: query).
	self assert: (application availableQueries includes: query2).
	browser clearQueries.
	self deny: (application availableQueries includes: query).
	self deny: (application availableQueries includes: query2).
]

{ #category : 'tests - actions' }
MiQueriesBrowserTest >> testFollowEntity [

	| previousResult newResult |
	self queriesListPresenter addNewFirstLevelQuery. "Modify the query to not have an empty result"
	self queriesListPresenter queryItemsPresenters first updateQueryConfiguratorPresenterFor: FQBooleanQuery.
	self queriesListPresenter queryItemsPresenters first queryConfiguratorPresenter query property: #isDead.

	self queriesListPresenter addNewChildQueryAction: self queriesListPresenter queryItemsPresenters first query. "Modify the query to not have an empty result"
	self queriesListPresenter queryItemsPresenters second updateQueryConfiguratorPresenterFor: FQStringQuery.
	self queriesListPresenter queryItemsPresenters second queryConfiguratorPresenter query
		property: #name;
		comparator: #includesSubstring:;
		valueToCompare: ''.

	previousResult := (self queriesListPresenter queryItemsPresenters collect: #query) collect: #result.
	self application miPropagate: helper methods.
	newResult := (self queriesListPresenter queryItemsPresenters collect: #query) collect: #result. "When a new entity is received from the bus we need to keep the same queries but
	update the result of the queries with the new entity"
	self assert: previousResult size equals: newResult size.
	previousResult with: newResult do: [ :a :b | self denyCollection: a hasSameElements: b ]
]

{ #category : 'tests' }
MiQueriesBrowserTest >> testInitializePresenters [

	self
		assertCollection: browser specModel selectedQueryResult
		hasSameElements: helper classesAndMethods.

	self assert: browser layout isNotNil.
	self assert: self queryCodePresenter class equals: QueryCodePresenter.
	self assert: self queryCodePresenter text isNotEmpty.
	self
		assert: self queryResultTreePresenter class
		equals: MiMooseGroupsTreeTablePresenter.
	self
		assertCollection: browser specModel selectedQueryResult
		hasSameElements: helper classesAndMethods
]

{ #category : 'tests' }
MiQueriesBrowserTest >> testRegisterAtStartup [

	self assert: (browser application producersOf: FQAbstractQuery) size equals: 1.
]

{ #category : 'tests' }
MiQueriesBrowserTest >> testRemoveQuery [

	| query query2 |
	query := FQBooleanQuery new property: #isAbstract.
	query beChildOf: browser rootQuery.
	query2 := FQBooleanQuery new property: #isStub.
	query2 beChildOf: query.

	browser specModel removeQuery: query.
	self
		assertCollection: self queryResultTreeItems
		hasSameElements: browser specModel selectedQueryResult
]

{ #category : 'tests' }
MiQueriesBrowserTest >> testSelectQuery [

	| query newQuery |
	query := (FQBooleanQuery property: #isDead) beChildOf:
		         browser rootQuery.

	browser selectQuery: query.

	self
		assertCollection: self queryResultTreeItems
		hasSameElements: query result.

	newQuery := Smalltalk compiler evaluate: self queryCodePresenter text.
	self assert: newQuery equals: query
]

{ #category : 'tests' }
MiQueriesBrowserTest >> testSetModelBeforeInitialization [

	self assert: browser specModel class equals: MiQueriesModel
]

{ #category : 'tests' }
MiQueriesBrowserTest >> testUnregisterAtClose [

	browser window close.
	self
		assert: (browser application producersOf: FQAbstractQuery) size
		equals: 0
]

{ #category : 'defaults' }
MiQueriesBrowserTest >> unionQuery [

	| subqueries union |
	subqueries := {
		              (FQBooleanQuery property: #isDead).
		              (FQTypeQuery new type: FamixStClass) }.
	union := FQUnionQuery new.
	subqueries do: [ :parent | parent beChildOf: browser rootQuery ].

	union subqueries: subqueries.
	^ union
]
