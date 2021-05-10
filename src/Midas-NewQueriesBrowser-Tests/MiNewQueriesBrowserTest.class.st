Class {
	#name : #MiNewQueriesBrowserTest,
	#superclass : #MiAbstractBrowserTest,
	#instVars : [
		'helper'
	],
	#category : #'Midas-NewQueriesBrowser-Tests-Main presenters'
}

{ #category : #'tests - actions' }
MiNewQueriesBrowserTest >> assertFollowActionFor: notUsed [

	self assert: browser queriesHistory size equals: 1.
	self
		assertCollection: browser queryResultTreePresenter items
		hasSameElements: browser currentQuery result
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

{ #category : #tests }
MiNewQueriesBrowserTest >> testAddNewQuery [

	"add a new query"

	| query |
	query := (FQBooleanQuery property: #isDead) beChildOf:
		         browser currentQuery.
	self deny: (browser queriesHistory includes: query).
	browser addNewQuery: query.
	self assert: (browser queriesHistory includes: query).
	self assert: browser currentQuery equals: query.
	self
		assertCollection: browser queryResultTreePresenter items
		hasSameElements: query result.
	self
		assertCollection: browser queryResultEntities
		hasSameElements: query result
]

{ #category : #tests }
MiNewQueriesBrowserTest >> testInitializePresenters [

	self
		assertCollection: browser queryResultEntities
		hasSameElements: helper classesAndMethods
]

{ #category : #tests }
MiNewQueriesBrowserTest >> testOpen [

	self assert: browser window isBuilt
]

{ #category : #tests }
MiNewQueriesBrowserTest >> testQueryResultEntities [

	self
		assert: browser queryResultTreePresenter class
		identicalTo: MiResultTreePresenter.
	self
		assertCollection: browser queryResultTreePresenter items
		hasSameElements: browser queryResultEntities
]

{ #category : #tests }
MiNewQueriesBrowserTest >> testRemoveQuery [

	| query |
	query := FQBooleanQuery new property: #isAbstract.
	query beChildOf: browser getRootQuery.
	self assert: browser queriesHistory size equals: 1.
	browser addNewQuery: query.
	self assert: browser queriesHistory size equals: 2.
	self assert: (browser queriesHistory includes: query).
	browser removeQuery: browser currentQuery.
	self assert: browser queriesHistory size equals: 1.
	self deny: (browser queriesHistory includes: query)
]

{ #category : #tests }
MiNewQueriesBrowserTest >> testSelectQuery [

	| query1 |
	query1 := (FQBooleanQuery property: #isDead) beChildOf:
		          browser getRootQuery.
	browser addNewQuery: query1.
	self assert: browser currentQuery equals: query1.
	browser addNewQuery:
		((FQTypeQuery new type: FamixStClass) beChildOf: query1).
	self deny: browser currentQuery equals: query1.
	browser selectQuery: query1.
	self assert: browser currentQuery equals: query1.
	self
		assertCollection: browser queryResultTreePresenter items
		hasSameElements: query1 result.
	self
		assertCollection: browser currentQuery result
		hasSameElements: query1 result
]

{ #category : #tests }
MiNewQueriesBrowserTest >> testUpdateForBinaryQuery [

	| unionQuery |
	unionQuery := self unionQuery.
	browser addNewQuery: unionQuery.
	self assert: (browser queriesHistory includes: unionQuery).
	self assert: browser currentQuery equals: unionQuery.
	self
		assertCollection: browser queryResultTreePresenter items
		hasSameElements: unionQuery result
]

{ #category : #running }
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
