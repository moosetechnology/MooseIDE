"
A MiNewQueriesBrowserTest is a test class for testing the behavior of MiNewQueriesBrowser
"
Class {
	#name : #MiQueriesBrowserTest,
	#superclass : #MiAbstractBrowserTest,
	#instVars : [
		'helper'
	],
	#category : #'MooseIDE-QueriesBrowser-Tests-Queries Browser'
}

{ #category : #running }
MiQueriesBrowserTest >> browserClass [

	^ MiQueriesBrowser
]

{ #category : #running }
MiQueriesBrowserTest >> setUp [

	super setUp.
	helper := FQTestsHelper current.
	browser receiveEntity: helper classesAndMethods
]

{ #category : #tests }
MiQueriesBrowserTest >> testActivateActionButtons [
	self skip.
	{ MiInspectCommand . MiPropagateCommand }
	do: [ :cmdClass | self deny: (self actionButton: cmdClass) isEnabled ].
	self assert: (self actionButton: MiDragWindowCommand) isEnabled.

	self bus globallySelect: helper methods.
	{ MiInspectCommand . MiPropagateCommand . MiDragWindowCommand }
	do: [ :cmdClass | self assert: (self actionButton: cmdClass) isEnabled ].

]

{ #category : #tests }
MiQueriesBrowserTest >> testAddNewNAryQuery [

	| unionQuery |
	unionQuery := self unionQuery.
	browser containedBrowser rootQuery addChild: unionQuery.
	browser containedBrowser selectQuery: unionQuery.
	self assert: (browser containedBrowser rootQuery children includes: unionQuery).
	self assert: browser containedBrowser selectedQuery equals: unionQuery.
	self
		assertCollection: browser containedBrowser queryResultTreePresenter items
		hasSameElements: unionQuery result
]

{ #category : #tests }
MiQueriesBrowserTest >> testBrowserFollowsPrivatelBus [

	self assert: browser containedBrowser privateBus equals: browser privateBus
]

{ #category : #'tests - actions' }
MiQueriesBrowserTest >> testFollowEntity [

	| previousResult newResult |
	browser containedBrowser queriesListPresenter addNewFirstLevelQuery.
	"Modify the query to not have an empty result"
	browser containedBrowser queriesListPresenter queryItemsPresenters first 
		updateQueryConfiguratorPresenterFor: FQBooleanQuery.
	browser containedBrowser queriesListPresenter queryItemsPresenters first
		queryConfiguratorPresenter query property: #isDead.

	browser containedBrowser queriesListPresenter addNewChildQueryAction:
		browser containedBrowser queriesListPresenter queryItemsPresenters first query.
	"Modify the query to not have an empty result"
	browser containedBrowser queriesListPresenter queryItemsPresenters second 
		updateQueryConfiguratorPresenterFor: FQStringQuery.
	browser containedBrowser queriesListPresenter queryItemsPresenters second
		queryConfiguratorPresenter query
		property: #name;
		comparator: #includesSubstring:;
		valueToCompare: ''.

	previousResult := (browser containedBrowser queriesListPresenter queryItemsPresenters 
		                   collect: #query) collect: #result.
	self bus globallySelect: helper methods.
	newResult := (browser containedBrowser queriesListPresenter queryItemsPresenters 
		              collect: #query) collect: #result.
	"When a new entity is received from the bus we need to keep the same queries but
	update the result of the queries with the new entity"
	self assert: previousResult size equals: newResult size.
	previousResult
		with: newResult
		do: [ :a :b | self denyCollection: a hasSameElements: b ]
]

{ #category : #tests }
MiQueriesBrowserTest >> testInitializePresenters [

	self
		assertCollection: browser containedBrowser queryResultEntities
		hasSameElements: helper classesAndMethods.

	self assert: browser containedBrowser layout isNotNil.
	self
		assert: browser containedBrowser queryCodePresenter class
		equals: QueryCodePresenter.
	self assert: browser containedBrowser queryCodePresenter text isNotEmpty.
	self
		assert: browser containedBrowser queryResultTreePresenter class
		equals: QueryResultTreePresenter.
	self
		assertCollection: browser containedBrowser queryResultEntities
		hasSameElements: helper classesAndMethods
]

{ #category : #tests }
MiQueriesBrowserTest >> testRegisterAtStartup [

	self assert: (browser application producersOf: FQAbstractQuery) size equals: 1.
]

{ #category : #tests }
MiQueriesBrowserTest >> testRemoveNAryQuery [

	| unionQuery firstParent |
	unionQuery := self unionQuery.
	browser containedBrowser rootQuery addChild: unionQuery.
	firstParent := unionQuery subqueries first.
	browser containedBrowser removeQuery: unionQuery.
	self deny: (browser containedBrowser rootQuery children includes: unionQuery)
]

{ #category : #tests }
MiQueriesBrowserTest >> testRemoveQuery [

	| query query2 |
	query := FQBooleanQuery new property: #isAbstract.
	query beChildOf: browser containedBrowser rootQuery.
	query2 := FQBooleanQuery new property: #isStub.
	query2 beChildOf: query.

	browser containedBrowser removeQuery: query.
	self deny: (browser containedBrowser rootQuery children includes: query).
	self deny: (browser containedBrowser rootQuery children includes: query2).
	self
		assertCollection: browser containedBrowser queryResultTreePresenter items
		hasSameElements: browser containedBrowser queryResultEntities
]

{ #category : #tests }
MiQueriesBrowserTest >> testSelectQuery [

	| query previousCurrentQuery |
	query := (FQBooleanQuery property: #isDead) beChildOf:
		         browser containedBrowser rootQuery.
	previousCurrentQuery := browser containedBrowser selectedQuery.
	browser containedBrowser selectQuery: query.
	self deny: previousCurrentQuery equals: browser containedBrowser selectedQuery.
	self assert: browser containedBrowser selectedQuery equals: query.
	self
		assertCollection: browser containedBrowser queryResultTreePresenter items
		hasSameElements: query result.
	"Check if the code presenter changed its text to the new query"
	self
		assert: browser containedBrowser queryCodePresenter text
		equals: (EFFormatter format: (RBParser parseExpression:
					  (String streamContents: [ :s | query storeOn: s ])))
]

{ #category : #tests }
MiQueriesBrowserTest >> testSetModelBeforeInitialization [

	self assert: browser containedBrowser rootQuery class equals: FQRootQuery
]

{ #category : #tests }
MiQueriesBrowserTest >> testUnregisterAtClose [
	browser window close.
	self assert: (browser application producersOf: FQAbstractQuery) size equals: 0.
]

{ #category : #defaults }
MiQueriesBrowserTest >> unionQuery [

	| subqueries union |
	subqueries := { 
		           (FQBooleanQuery property: #isDead).
		           (FQTypeQuery new type: FamixStClass) }.
	union := FQUnionQuery new.
	subqueries do: [ :parent | 
		parent beChildOf: browser containedBrowser rootQuery.
		browser containedBrowser selectQuery: parent.
		parent addChild: union ].
	union subqueries: subqueries.
	^ union
]
