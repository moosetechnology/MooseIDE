Class {
	#name : #MiQueriesModelTest,
	#superclass : #TestCase,
	#instVars : [
		'specModel',
		'previousApplication',
		'application'
	],
	#category : #'MooseIDE-QueriesBrowser-Tests-Queries Browser'
}

{ #category : #running }
MiQueriesModelTest >> setUp [

	| browser |
	super setUp.

	specModel := MiQueriesModel new.

	previousApplication := MiApplication current.
	application := MiTestApplication new.
	MiApplication current: application.

	browser := MiQueriesBrowser
		           newApplication: application
		           model: specModel.
	browser followEntity: FQTestsHelper new classesAndMethods
]

{ #category : #running }
MiQueriesModelTest >> tearDown [

	MiApplication reset.
	MiApplication current: previousApplication.
	previousApplication beDropFilesHandler.
	super tearDown
]

{ #category : #tests }
MiQueriesModelTest >> testAddNewNAryQuery [

	| unionQuery |
	unionQuery := self unionQuery.

	specModel rootQuery addChild: unionQuery.
	specModel selectedQuery: unionQuery.

	self assert: (specModel rootQuery children includes: unionQuery).
	self assert: specModel selectedQuery equals: unionQuery
]

{ #category : #tests }
MiQueriesModelTest >> testClearQueries [

	| query query2 |
	query := FQBooleanQuery new property: #isAbstract.
	query beChildOf: specModel rootQuery.
	query2 := FQBooleanQuery new property: #isStub.
	query2 beChildOf: query.

	specModel selectedQuery: query2.

	self assert: (specModel rootQuery allChildren includes: query).
	self assert: (specModel rootQuery allChildren includes: query2).
	self assert: specModel selectedQuery equals: query2.
	specModel clearQueries.
	self assert: specModel rootQuery allChildren isEmpty.
	self assert: specModel selectedQuery equals: specModel rootQuery
]

{ #category : #tests }
MiQueriesModelTest >> testRemoveNAryQuery [

	| unionQuery |
	unionQuery := self unionQuery.
	specModel rootQuery addChild: unionQuery.

	self
		assert: specModel rootQuery children anyOne
		equals: unionQuery subqueries first.

	specModel removeQuery: unionQuery.

	self deny: (specModel rootQuery children includes: unionQuery)
]

{ #category : #tests }
MiQueriesModelTest >> testRemoveQuery [

	| query query2 |
	query := FQBooleanQuery new property: #isAbstract.
	query beChildOf: specModel rootQuery.
	query2 := FQBooleanQuery new property: #isStub.
	query2 beChildOf: query.

	specModel removeQuery: query.
	
	self deny: (specModel rootQuery children includes: query).
	self deny: (specModel rootQuery children includes: query2)
]

{ #category : #tests }
MiQueriesModelTest >> testResetRootQueryForEntities [

	| query1 initialResult newResult |
	query1 := FQStringQuery defaultForParent: specModel rootQuery.
	query1
		property: #name;
		comparator: #includesSubstring:;
		valueToCompare: 'a'.

	specModel selectedQuery: query1.

	initialResult := specModel rootQuery result.
	newResult := MooseGroup with:
		             (MooseEntity new mooseModel: (MooseModel new
				               name: 'testModel';
				               yourself)).

	specModel resetRootQueryForEntities: newResult.

	self assert: specModel rootQuery result equals: newResult.
	self assert: specModel selectedQuery equals: specModel rootQuery
]

{ #category : #defaults }
MiQueriesModelTest >> unionQuery [

	| subqueries union |
	subqueries := {
		              (FQBooleanQuery property: #isDead).
		              (FQTypeQuery new type: FamixStClass) }.
	union := FQUnionQuery new.
	subqueries do: [ :parent | parent beChildOf: specModel rootQuery ].

	union subqueries: subqueries.
	^ union
]
