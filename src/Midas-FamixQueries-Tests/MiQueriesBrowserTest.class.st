Class {
	#name : #MiQueriesBrowserTest,
	#superclass : #MiAbstractBrowserTest,
	#instVars : [
		'helper'
	],
	#category : #'Midas-FamixQueries-Tests-Presenters'
}

{ #category : #running }
MiQueriesBrowserTest >> browserClass [
	^ MiQueriesBrowser
]

{ #category : #running }
MiQueriesBrowserTest >> classToTest [
	^ MiQueriesBrowser
]

{ #category : #running }
MiQueriesBrowserTest >> setUp [
	super setUp.
	helper := FQTestsHelper current.
	browser selectEntity: helper classesAndMethods
]

{ #category : #tests }
MiQueriesBrowserTest >> testInitialization [
	self
		assertCollection: browser entities
		hasSameElements: helper classesAndMethods
]

{ #category : #tests }
MiQueriesBrowserTest >> testQueriesTree [
	self flag: #FQImprove.
	self
		assert: browser queriesTree class
		identicalTo: MiRoassalQueryPresenter
]

{ #category : #tests }
MiQueriesBrowserTest >> testQueryResult [
	self
		assert: browser queryResult class
		identicalTo: MiResultTreePresenter.
	self
		assertCollection: browser queryResult items
		hasSameElements: browser entities
]

{ #category : #tests }
MiQueriesBrowserTest >> testRemoveBinaryQuery [

	| unionQuery firstParent |
	unionQuery := self unionQuery.
	browser updateForQuery: unionQuery.
	firstParent := unionQuery parents first.
	
	browser removeQuery: unionQuery.
	self
		deny: (browser queries anySatisfy: [ :query | query == unionQuery ]).
	self assert: browser selectedQuery equals: firstParent.
	self assert: browser queriesTree selectedItem equals: firstParent.
	self
		assertCollection: browser queryResult items
		hasSameElements: firstParent result
]

{ #category : #tests }
MiQueriesBrowserTest >> testRemoveQuery [
	| query |
	query := FQBooleanQuery new property: #isAbstract.
	query beChildOf: browser initialQuery.
	browser updateForQuery: query.
	
	browser removeQuery: browser selectedQuery.
	
	self
		deny:
			(browser queries
				anySatisfy: [ :q | q == query  ]).
	self
		assert: browser selectedQuery
		equals: browser initialQuery.
	self
		assert: browser queriesTree selectedItem
		equals: browser initialQuery.
	self
		assertCollection: browser queryResult items
		hasSameElements: helper classesAndMethods
]

{ #category : #tests }
MiQueriesBrowserTest >> testSelectQuery [
	| query1 |
	query1 := (FQBooleanQuery property: #isDead)
		beChildOf: browser initialQuery.
	browser updateForQuery: query1.
	browser
		updateForQuery: ((FQTypeQuery new type: FamixStClass) beChildOf: query1).
	browser selectQuery: query1.
	self assert: browser selectedQuery equals: query1.
	self assert: browser queriesTree selectedItem equals: query1.
	self
		assertCollection: browser queryResult items
		hasSameElements: query1 result
]

{ #category : #tests }
MiQueriesBrowserTest >> testUpdateForBinaryQuery [
	| unionQuery |
	unionQuery := self unionQuery.
	browser updateForQuery: unionQuery.
	self assert: (browser queries includes: unionQuery).
	self assert: browser selectedQuery equals: unionQuery.
	self assert: browser queriesTree selectedItem equals: unionQuery.
	self
		assertCollection: browser queryResult items
		hasSameElements: unionQuery result
]

{ #category : #tests }
MiQueriesBrowserTest >> testUpdateForQuery [
	| query |
	query := (FQBooleanQuery property: #isDead)
		beChildOf: browser initialQuery.
	browser updateForQuery: query.
	self assert: (browser queries includes: query).
	self assert: browser selectedQuery equals: query.
	self assert: browser queriesTree selectedItem equals: query.
	self
		assertCollection: browser queryResult items
		hasSameElements: query result
]

{ #category : #running }
MiQueriesBrowserTest >> unionQuery [
	| parents union |
	parents := {(FQBooleanQuery property: #isDead).
	(FQTypeQuery new type: FamixStClass)}.
	union := FQUnionQuery new.
	parents
		do: [ :parent | 
			parent beChildOf: browser initialQuery.
			browser updateForQuery: parent.
			parent addChild: union ].
	union parents: parents.
	^ union
]
