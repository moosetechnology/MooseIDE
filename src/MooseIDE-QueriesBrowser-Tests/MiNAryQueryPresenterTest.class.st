Class {
	#name : 'MiNAryQueryPresenterTest',
	#superclass : 'MiQueryConfiguratorPresenterTest',
	#category : 'MooseIDE-QueriesBrowser-Tests-Queries Configuration',
	#package : 'MooseIDE-QueriesBrowser-Tests',
	#tag : 'Queries Configuration'
}

{ #category : 'tests' }
MiNAryQueryPresenterTest >> assertSubpresentersAreConfigured [

	self assert: presenter query subqueries size equals: 3.
	self assert: self subqueryDropLists size equals: 3
]

{ #category : 'running' }
MiNAryQueryPresenterTest >> classToTest [

	^ MiNAryQueryPresenter
]

{ #category : 'running' }
MiNAryQueryPresenterTest >> configureInnerQueries [

	| query1 query2 query3 |
	browser followEntity: helper classesAndMethods.
	query1 := FQStringQuery defaultForParent: browser rootQuery.
	query1
		property: #name;
		comparator: #includesSubstring:;
		valueToCompare: 'a'.

	query2 := FQScopeQuery defaultForParent: browser rootQuery.
	query2
		queryContainers;
		scope: FamixStClass.

	query3 := FQBooleanQuery defaultForParent: browser rootQuery.
	query3 property: #isStub.

	"Add the queries to the browser"
	queriesListPresenter
		addNewFirstLevelQuery;
		addNewFirstLevelQuery;
		addNewFirstLevelQuery.
	{
		query1.
		query2.
		query3 }
		with: queriesListPresenter queryItemsPresenters
		do: [ :a :b | b configureFor: a ].
	^ {
		  query1.
		  query2.
		  query3 }
]

{ #category : 'tests' }
MiNAryQueryPresenterTest >> createNewQuery [

	^ FQUnionQuery subqueries: self configureInnerQueries
]

{ #category : 'running' }
MiNAryQueryPresenterTest >> createUnconfiguredQuery [

	| superPresenter |
	queriesListPresenter addNewFirstLevelQuery.

	superPresenter := queriesListPresenter componentList items last.
	superPresenter queryTypesDropList selectItem: self queryClass.

	presenter := superPresenter queryConfiguratorPresenter
]

{ #category : 'running' }
MiNAryQueryPresenterTest >> queryClass [

	^ FQUnionQuery
]

{ #category : 'running' }
MiNAryQueryPresenterTest >> resetPresenterWithEntities: aMooseGroup [

	queriesListPresenter reinitializeQueryPresenters.
	browser followEntity: aMooseGroup.

	self configureInnerQueries.

	self createUnconfiguredQuery
]

{ #category : 'accessing-subpresenters' }
MiNAryQueryPresenterTest >> subqueryDropLists [

	^ presenter presenterAt: #subqueryDropLists
]

{ #category : 'tests' }
MiNAryQueryPresenterTest >> testIsQueryUsed [

	self assert:
		(presenter isQueryUsed: self subqueryDropLists first selectedItem).

	self deny:
		(presenter isQueryUsed: self subqueryDropLists first items second)
]

{ #category : 'tests' }
MiNAryQueryPresenterTest >> testNormalQueryInitialization [

	self subqueryDropLists first selectIndex: 1.
	self subqueryDropLists second selectIndex: 2.

	self assert: presenter query class identicalTo: self queryClass
]

{ #category : 'tests' }
MiNAryQueryPresenterTest >> testPresenters [

	self assert: self subqueryDropLists isCollection.
	self
		assert: (presenter presenterAt: #addSubqueryToLayoutButton) class
		equals: SpButtonPresenter.
	self
		assert:
		(presenter presenterAt: #removeSubqueryFromLayoutButton) class
		equals: SpButtonPresenter
]

{ #category : 'tests' }
MiNAryQueryPresenterTest >> testPresentersOnImpossibleQuery [

	self assert: true
]

{ #category : 'tests' }
MiNAryQueryPresenterTest >> testQueryValidity [

	self deny: presenter query isValid.

	self subqueryDropLists withIndexDo: [ :droplist :i | 
		droplist selectIndex: i ].

	self assert: presenter query isValid
]
