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
	browser updateForQuery: query.
	browser removeQuery: browser currentQuery.
	self assert: browser queriesHistory size equals: 1.
	self deny: (browser queriesHistory includes: query)
]

{ #category : #tests }
MiNewQueriesBrowserTest >> testSelectQuery [

	| query1 |
	query1 := (FQBooleanQuery property: #isDead) beChildOf:
		          browser getRootQuery.
	browser updateForQuery: query1.
	browser updateForQuery:
		((FQTypeQuery new type: FamixStClass) beChildOf: query1).
	browser selectQuery: query1.
	self assert: browser currentQuery equals: query1.
	self
		assertCollection: browser queryResultTreePresenter items
		hasSameElements: query1 result.
	self
		assertCollection: browser queryResultEntities
		hasSameElements: query1 result
]

{ #category : #tests }
MiNewQueriesBrowserTest >> testUpdateForBinaryQuery [

	| unionQuery |
	unionQuery := self unionQuery.
	browser updateForQuery: unionQuery.
	self assert: (browser queriesHistory includes: unionQuery).
	self assert: browser currentQuery equals: unionQuery.
	self
		assertCollection: browser queryResultTreePresenter items
		hasSameElements: unionQuery result
]

{ #category : #tests }
MiNewQueriesBrowserTest >> testUpdateForQuery [

	| query |
	query := (FQBooleanQuery property: #isDead) beChildOf:
		         browser currentQuery.
	browser updateForQuery: query.
	self assert: (browser queriesHistory includes: query).
	self assert: browser currentQuery equals: query.
	self
		assertCollection: browser queryResultTreePresenter items
		hasSameElements: query result.
	self
		assertCollection: browser queryResultEntities
		hasSameElements: query result
]

{ #category : #running }
MiNewQueriesBrowserTest >> unionQuery [
	| parents union |
	parents := {(FQBooleanQuery property: #isDead).
	(FQTypeQuery new type: FamixStClass)}.
	union := FQUnionQuery new.
	parents
		do: [ :parent | 
			parent beChildOf: browser getRootQuery.
			browser updateForQuery: parent.
			parent addChild: union ].
	union parents: parents.
	^ union
]
