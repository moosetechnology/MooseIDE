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

{ #category : #'tests - actions' }
MiNewQueriesBrowserTest >> assertFollowActionFor: aMooseObject [

	"Override to test follow action"

	
]

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
	browser addNewQuery: unionQuery.
	self assert: (browser queriesHistory includes: unionQuery).
	self assert: browser currentQuery equals: unionQuery.
	self
		assertCollection: browser queryResultTreePresenter items
		hasSameElements: unionQuery result
]

{ #category : #test }
MiNewQueriesBrowserTest >> testAddNewQuery [

	| query previousCurrentQuery |
	query := (FQBooleanQuery property: #isDead) beChildOf:
		         browser getRootQuery.
	previousCurrentQuery := browser currentQuery.
	self assert: browser queriesHistory size equals: 1.
	browser addNewQuery: query.
	self assert: browser queriesHistory size equals: 2.
	self assert: (browser queriesHistory includes: query).
	self deny: previousCurrentQuery equals: browser currentQuery.
	self assert: browser currentQuery equals: query.

	"Check if the query was selected"
	self testSelectQuery
]

{ #category : #tests }
MiNewQueriesBrowserTest >> testInitialization [

	self
		assertCollection: browser queryResultEntities
		hasSameElements: helper classesAndMethods
]

{ #category : #tests }
MiNewQueriesBrowserTest >> testRemoveBinaryQuery [

	| unionQuery firstParent |
	unionQuery := self unionQuery.
	browser addNewQuery: unionQuery.
	firstParent := unionQuery parents first.

	browser removeQuery: unionQuery.
	self deny: (browser queriesHistory includes: unionQuery)
]

{ #category : #tests }
MiNewQueriesBrowserTest >> testRemoveQuery [

	| query query2 |
	query := FQBooleanQuery new property: #isAbstract.
	query beChildOf: browser getRootQuery.
	query2 := FQBooleanQuery new property: #isStub.
	query2 beChildOf: browser getRootQuery.

	self assert: browser queriesHistory size equals: 1.
	browser addNewQuery: query.
	"Simulate the user changes the query"
	browser selectQuery: query2.
	browser removeQuery: query.

	self deny: (browser queriesHistory includes: query).
	self assert: browser queriesHistory size equals: 1.
	self
		assertCollection: browser queryResultTreePresenter items
		hasSameElements: browser queryResultEntities
]

{ #category : #tests }
MiNewQueriesBrowserTest >> testSelectQuery [

	| query |
	query := (FQBooleanQuery property: #isDead) beChildOf:
		          browser getRootQuery.
	browser selectQuery: query.
	self assert: browser currentQuery equals: query.
	self
		assertCollection: browser queryResultTreePresenter items
		hasSameElements: query result.
	"Check if the code presenter changed its text to the new query"
	self
		assert: browser queryCodePresenter text
		equals: (EFFormatter format: (RBParser parseExpression:
					  (String streamContents: [ :s | query storeOn: s ])))
]

{ #category : #defaults }
MiNewQueriesBrowserTest >> unionQuery [

	| parents union |
	parents := { 
		           (FQBooleanQuery property: #isDead).
		           (FQTypeQuery new type: FamixStClass) }.
	union := FQUnionQuery new.
	parents do: [ :parent | 
		parent beChildOf: browser getRootQuery.
		browser addNewQuery: parent.
		parent addChild: union ].
	union parents: parents.
	^ union
]
