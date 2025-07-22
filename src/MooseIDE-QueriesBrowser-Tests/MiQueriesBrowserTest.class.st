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

{ #category : 'tests' }
MiQueriesBrowserTest >> queryResultTreeItems [

	| resultTree |
	resultTree := browser queryResultTreePresenter.
	^ resultTree roots flatCollect: [ :root |
		  resultTree childrenFor: root ]
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
	self assert: (browser rootQuery children includes: unionQuery).
	self assert: browser selectedQuery equals: unionQuery.
	self
		assertCollection: self queryResultTreeItems
		hasSameElements: unionQuery result
]

{ #category : 'tests' }
MiQueriesBrowserTest >> testCanTagEntities [
	self deny: browser canTagEntities 
]

{ #category : 'tests - actions' }
MiQueriesBrowserTest >> testFollowEntity [

	| previousResult newResult |
	browser queriesListPresenter addNewFirstLevelQuery.
	"Modify the query to not have an empty result"
	browser queriesListPresenter queryItemsPresenters first 
		updateQueryConfiguratorPresenterFor: FQBooleanQuery.
	browser queriesListPresenter queryItemsPresenters first
		queryConfiguratorPresenter query property: #isDead.

	browser queriesListPresenter addNewChildQueryAction:
		browser queriesListPresenter queryItemsPresenters first query.
	"Modify the query to not have an empty result"
	browser queriesListPresenter queryItemsPresenters second 
		updateQueryConfiguratorPresenterFor: FQStringQuery.
	browser queriesListPresenter queryItemsPresenters second
		queryConfiguratorPresenter query
		property: #name;
		comparator: #includesSubstring:;
		valueToCompare: ''.

	previousResult := (browser queriesListPresenter queryItemsPresenters 
		                   collect: #query) collect: #result.
	self bus globallySelect: helper methods.
	newResult := (browser queriesListPresenter queryItemsPresenters 
		              collect: #query) collect: #result.
	"When a new entity is received from the bus we need to keep the same queries but
	update the result of the queries with the new entity"
	self assert: previousResult size equals: newResult size.
	previousResult
		with: newResult
		do: [ :a :b | self denyCollection: a hasSameElements: b ]
]

{ #category : 'tests' }
MiQueriesBrowserTest >> testInitializePresenters [

	self
		assertCollection: browser queryResultEntities
		hasSameElements: helper classesAndMethods.

	self assert: browser layout isNotNil.
	self
		assert: browser queryCodePresenter class
		equals: QueryCodePresenter.
	self assert: browser queryCodePresenter text isNotEmpty.
	self
		assert: browser queryResultTreePresenter class
		equals: MiMooseGroupsTreeTablePresenter.
	self
		assertCollection: browser queryResultEntities
		hasSameElements: helper classesAndMethods
]

{ #category : 'tests' }
MiQueriesBrowserTest >> testRegisterAtStartup [

	self assert: (browser application producersOf: FQAbstractQuery) size equals: 1.
]

{ #category : 'tests' }
MiQueriesBrowserTest >> testRemoveNAryQuery [

	| unionQuery firstParent |
	unionQuery := self unionQuery.
	browser rootQuery addChild: unionQuery.
	firstParent := unionQuery subqueries first.
	browser removeQuery: unionQuery.
	self deny: (browser rootQuery children includes: unionQuery)
]

{ #category : 'tests' }
MiQueriesBrowserTest >> testRemoveQuery [

	| query query2 |
	query := FQBooleanQuery new property: #isAbstract.
	query beChildOf: browser rootQuery.
	query2 := FQBooleanQuery new property: #isStub.
	query2 beChildOf: query.

	browser removeQuery: query.
	self deny: (browser rootQuery children includes: query).
	self deny: (browser rootQuery children includes: query2).
	self
		assertCollection: self queryResultTreeItems
		hasSameElements: browser queryResultEntities
]

{ #category : 'tests' }
MiQueriesBrowserTest >> testSelectQuery [

	| query previousCurrentQuery newQuery |
	query := (FQBooleanQuery property: #isDead) beChildOf:
		         browser rootQuery.
	previousCurrentQuery := browser selectedQuery.
	browser selectQuery: query.
	self deny: previousCurrentQuery equals: browser selectedQuery.
	self assert: browser selectedQuery equals: query.
	self
		assertCollection: self queryResultTreeItems
		hasSameElements: query result.
	"Check if the code presenter changed its text to the new query"

	newQuery := Smalltalk compiler evaluate:
		            browser queryCodePresenter text.
	self assert: newQuery class equals: query class.
	self assert: newQuery property equals: query property
]

{ #category : 'tests' }
MiQueriesBrowserTest >> testSetModelBeforeInitialization [

	self assert: browser rootQuery class equals: FQRootQuery
]

{ #category : 'tests' }
MiQueriesBrowserTest >> testUnregisterAtClose [
	browser window close.
	self assert: (browser application producersOf: FQAbstractQuery) size equals: 0.
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
