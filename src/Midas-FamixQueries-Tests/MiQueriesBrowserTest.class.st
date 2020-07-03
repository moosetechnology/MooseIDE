Class {
	#name : #MiQueriesBrowserTest,
	#superclass : #TestCase,
	#instVars : [
		'presenter',
		'helper'
	],
	#category : #'Midas-FamixQueries-Tests-Presenters'
}

{ #category : #running }
MiQueriesBrowserTest >> classToTest [
	^ MiQueriesBrowser
]

{ #category : #running }
MiQueriesBrowserTest >> setUp [
	helper := FQTestsHelper current.
	presenter := self classToTest
		on:
			(FQRootQuery new
				result: helper classesAndMethods;
				yourself)
]

{ #category : #tests }
MiQueriesBrowserTest >> testInitialization [
	self
		assertCollection: presenter entities
		hasSameElements: helper classesAndMethods
]

{ #category : #tests }
MiQueriesBrowserTest >> testQueriesTree [
	self flag: #FQImprove.
	self
		assert: presenter queriesTree class
		identicalTo: MiRoassalQueryPresenter
]

{ #category : #tests }
MiQueriesBrowserTest >> testQueryResult [
	self
		assert: presenter queryResult class
		identicalTo: MiResultTreePresenter.
	self
		assertCollection: presenter queryResult items
		hasSameElements: presenter entities
]

{ #category : #tests }
MiQueriesBrowserTest >> testRemoveBinaryQuery [

	| unionQuery firstParent |
	unionQuery := self unionQuery.
	presenter updateForQuery: unionQuery.
	firstParent := unionQuery parents first.
	
	presenter removeQuery: unionQuery.
	self
		deny: (presenter queries anySatisfy: [ :query | query == unionQuery ]).
	self assert: presenter selectedQuery equals: firstParent.
	self assert: presenter queriesTree selectedItem equals: firstParent.
	self
		assertCollection: presenter queryResult items
		hasSameElements: firstParent result
]

{ #category : #tests }
MiQueriesBrowserTest >> testRemoveQuery [
	| query |
	query := FQBooleanQuery new property: #isAbstract.
	query beChildOf: presenter initialQuery.
	presenter updateForQuery: query.
	
	presenter removeQuery: presenter selectedQuery.
	
	self
		deny:
			(presenter queries
				anySatisfy: [ :q | q == query  ]).
	self
		assert: presenter selectedQuery
		equals: presenter initialQuery.
	self
		assert: presenter queriesTree selectedItem
		equals: presenter initialQuery.
	self
		assertCollection: presenter queryResult items
		hasSameElements: helper classesAndMethods
]

{ #category : #tests }
MiQueriesBrowserTest >> testSelectQuery [
	| query1 |
	query1 := (FQBooleanQuery property: #isDead)
		beChildOf: presenter initialQuery.
	presenter updateForQuery: query1.
	presenter
		updateForQuery: ((FQTypeQuery new type: FamixStClass) beChildOf: query1).
	presenter selectQuery: query1.
	self assert: presenter selectedQuery equals: query1.
	self assert: presenter queriesTree selectedItem equals: query1.
	self
		assertCollection: presenter queryResult items
		hasSameElements: query1 result
]

{ #category : #tests }
MiQueriesBrowserTest >> testUpdateForBinaryQuery [
	| unionQuery |
	unionQuery := self unionQuery.
	presenter updateForQuery: unionQuery.
	self assert: (presenter queries includes: unionQuery).
	self assert: presenter selectedQuery equals: unionQuery.
	self assert: presenter queriesTree selectedItem equals: unionQuery.
	self
		assertCollection: presenter queryResult items
		hasSameElements: unionQuery result
]

{ #category : #tests }
MiQueriesBrowserTest >> testUpdateForQuery [
	| query |
	query := (FQBooleanQuery property: #isDead)
		beChildOf: presenter initialQuery.
	presenter updateForQuery: query.
	self assert: (presenter queries includes: query).
	self assert: presenter selectedQuery equals: query.
	self assert: presenter queriesTree selectedItem equals: query.
	self
		assertCollection: presenter queryResult items
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
			parent beChildOf: presenter initialQuery.
			presenter updateForQuery: parent.
			parent addChild: union ].
	union parents: parents.
	^ union
]
