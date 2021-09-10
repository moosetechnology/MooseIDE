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
	browser selectEntity: helper classesAndMethods
]

{ #category : #tests }
MiQueriesBrowserTest >> testAddNewNAryQuery [

	| unionQuery |
	unionQuery := self unionQuery.
	browser rootQuery addChild: unionQuery.
	browser selectQuery: unionQuery.
	self assert: (browser rootQuery children includes: unionQuery).
	self assert: browser selectedQuery equals: unionQuery.
	self
		assertCollection: browser queryResultTreePresenter items
		hasSameElements: unionQuery result
]

{ #category : #tests }
MiQueriesBrowserTest >> testInitializePresenters [

	self
		assertCollection: browser queryResultEntities
		hasSameElements: helper classesAndMethods.

	self assert: browser layout isNotNil.
	self
		assert: browser queryCodePresenter class
		equals: MiQueryCodePresenter.
	self assert: browser queryCodePresenter text isNotEmpty.
	self
		assert: browser queryResultTreePresenter class
		equals: MiResultTreePresenter.
	self
		assertCollection: browser queryResultEntities
		hasSameElements: helper classesAndMethods
]

{ #category : #tests }
MiQueriesBrowserTest >> testRemoveNAryQuery [

	| unionQuery firstParent |
	unionQuery := self unionQuery.
	browser rootQuery addChild: unionQuery.
	firstParent := unionQuery subqueries first.
	browser removeQuery: unionQuery.
	self deny: (browser rootQuery children includes: unionQuery)
]

{ #category : #tests }
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
		assertCollection: browser queryResultTreePresenter items
		hasSameElements: browser queryResultEntities
]

{ #category : #tests }
MiQueriesBrowserTest >> testSelectQuery [

	| query previousCurrentQuery |
	query := (FQBooleanQuery property: #isDead) beChildOf:
		         browser rootQuery.
	previousCurrentQuery := browser selectedQuery.
	browser selectQuery: query.
	self deny: previousCurrentQuery equals: browser selectedQuery.
	self assert: browser selectedQuery equals: query.
	self
		assertCollection: browser queryResultTreePresenter items
		hasSameElements: query result.
	"Check if the code presenter changed its text to the new query"
	self
		assert: browser queryCodePresenter text
		equals: (EFFormatter format: (RBParser parseExpression:
					  (String streamContents: [ :s | query storeOn: s ])))
]

{ #category : #tests }
MiQueriesBrowserTest >> testSetModelBeforeInitialization [

	self assert: browser rootQuery class equals: FQRootQuery
]

{ #category : #defaults }
MiQueriesBrowserTest >> unionQuery [

	| subqueries union |
	subqueries := { 
		           (FQBooleanQuery property: #isDead).
		           (FQTypeQuery new type: FamixStClass) }.
	union := FQUnionQuery new.
	subqueries do: [ :parent | 
		parent beChildOf: browser rootQuery.
		browser selectQuery: parent.
		parent addChild: union ].
	union subqueries: subqueries.
	^ union
]
