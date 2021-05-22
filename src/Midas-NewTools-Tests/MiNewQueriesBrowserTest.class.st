"
A MiNewQueriesBrowserTest is a test class for testing the behavior of MiNewQueriesBrowser
"
Class {
	#name : #MiNewQueriesBrowserTest,
	#superclass : #MiAbstractBrowserTest,
	#instVars : [
		'helper'
	],
	#category : #'Midas-NewTools-Tests-Queries Browser'
}

{ #category : #running }
MiNewQueriesBrowserTest >> browserClass [

	^ MiNewQueriesBrowser
]

{ #category : #running }
MiNewQueriesBrowserTest >> setUp [

	super setUp.
	helper := FQTestsHelper current.
	browser selectEntity: helper classesAndMethods
]

{ #category : #test }
MiNewQueriesBrowserTest >> testAddNewBinaryQuery [

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

{ #category : #test }
MiNewQueriesBrowserTest >> testAddNewQuery [

	| query previousCurrentQuery |
	query := (FQBooleanQuery property: #isDead) beChildOf:
		         browser rootQuery.
	previousCurrentQuery := browser selectedQuery.
	browser addNewQuery: query.
	self deny: previousCurrentQuery equals: browser selectedQuery.
	self assert: browser selectedQuery equals: query.
	"Check if the query was selected"
	self testSelectQuery
]

{ #category : #tests }
MiNewQueriesBrowserTest >> testInitializePresenters [

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
MiNewQueriesBrowserTest >> testRemoveBinaryQuery [

	| unionQuery firstParent |
	unionQuery := self unionQuery.
	browser rootQuery addChild: unionQuery.
	firstParent := unionQuery parents first.
	browser removeQuery: unionQuery.
	self deny: (browser rootQuery children includes: unionQuery)
]

{ #category : #tests }
MiNewQueriesBrowserTest >> testRemoveQuery [

	| query query2 |
	query := FQBooleanQuery new property: #isAbstract.
	query beChildOf: browser rootQuery.
	query2 := FQBooleanQuery new property: #isStub.
	query2 beChildOf: browser rootQuery.

	browser rootQuery addChild: query.
	browser rootQuery addChild: query2.
	browser removeQuery: query.
	self deny: (browser rootQuery children includes: query).
	self
		assertCollection: browser queryResultTreePresenter items
		hasSameElements: browser queryResultEntities
]

{ #category : #tests }
MiNewQueriesBrowserTest >> testSelectQuery [

	| query |
	query := (FQBooleanQuery property: #isDead) beChildOf:
		         browser rootQuery.
	browser selectQuery: query.
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

{ #category : #test }
MiNewQueriesBrowserTest >> testSetModelBeforeInitialization [

	self assert: browser rootQuery class equals: FQRootQuery.
	self assert: browser selectedQuery equals: browser rootQuery
]

{ #category : #defaults }
MiNewQueriesBrowserTest >> unionQuery [

	| parents union |
	parents := { 
		           (FQBooleanQuery property: #isDead).
		           (FQTypeQuery new type: FamixStClass) }.
	union := FQUnionQuery new.
	parents do: [ :parent | 
		parent beChildOf: browser rootQuery.
		browser addNewQuery: parent.
		parent addChild: union ].
	union parents: parents.
	^ union
]
