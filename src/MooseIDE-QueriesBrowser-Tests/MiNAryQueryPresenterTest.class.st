Class {
	#name : #MiNAryQueryPresenterTest,
	#superclass : #MiQueryConfiguratorPresenterTest,
	#category : #'MooseIDE-QueriesBrowser-Tests-Queries Configuration'
}

{ #category : #tests }
MiNAryQueryPresenterTest >> assertSubpresentersAreConfigured [

	self assert: presenter query subqueries size equals: 3.
	self assert: presenter subqueryDropLists size equals: 3
]

{ #category : #running }
MiNAryQueryPresenterTest >> classToTest [

	^ MiNAryQueryPresenter
]

{ #category : #tests }
MiNAryQueryPresenterTest >> createNewQuery [

	| rootQuery query1 query2 query3 nAryQuery |
	rootQuery := FQRootQuery new
		result: helper classesAndMethods;
		yourself.
	query1 := FQStringQuery defaultForParent: rootQuery.
	query1 
		property: #name;
		comparator: #includesSubstring:;
		valueToCompare: 'a'.
	query2 := FQScopeQuery defaultForParent: rootQuery.
	query2
		directionStrategy: FQScopeUpAndDown;
		scope: FamixStClass.
	query3 := FQBooleanQuery defaultForParent: rootQuery.
	query3 property: #isStub.
	nAryQuery := FQUnionQuery subqueries: { query1 . query2 . query3 }.
	
	"Add the queries to the browser"
	browser queriesListPresenter
		addNewFirstLevelQuery;
		addNewFirstLevelQuery;
		addNewFirstLevelQuery.
	{ query1 . query2 . query3 }
		with: browser queriesListPresenter queryItemsPresenters
		do: [ :a :b |
			b configureFor: a ].
	^ nAryQuery
]

{ #category : #running }
MiNAryQueryPresenterTest >> queryClass [

	^ FQUnionQuery
]

{ #category : #running }
MiNAryQueryPresenterTest >> resetPresenterWithEntities: aMooseGroup [

	| builder superPresenter |
	browser := MiQueriesBrowser
		           newApplication: MiTestApplication current
		           model: (FQRootQuery new
				            result: aMooseGroup;
				            yourself).
	builder := browser instantiate: MiQueriesListPresenter on: browser.

	builder addNewFirstLevelQuery.
	builder queryItemsPresenters last queryTypesDropList selectItem:
		FQBooleanQuery.

	builder addNewFirstLevelQuery.
	builder queryItemsPresenters last queryTypesDropList selectItem:
		FQBooleanQuery.

	builder addNewFirstLevelQuery.
	builder queryItemsPresenters last queryTypesDropList selectItem:
		FQBooleanQuery.

	superPresenter := builder componentList items third.
	superPresenter queryTypesDropList selectItem: self queryClass.
	presenter := superPresenter queryConfiguratorPresenter
]

{ #category : #tests }
MiNAryQueryPresenterTest >> testIsQueryUsed [

	self assert: (presenter isQueryUsed: presenter subqueryDropLists first selectedItem).
	self deny: (presenter isQueryUsed: presenter subqueryDropLists first items second)
]

{ #category : #tests }
MiNAryQueryPresenterTest >> testNormalQueryInitialization [

	presenter subqueryDropLists first selectIndex: 1.
	presenter subqueryDropLists second selectIndex: 2.
	self assert: presenter query class identicalTo: self queryClass
]

{ #category : #tests }
MiNAryQueryPresenterTest >> testPresenters [

	self assert: presenter subqueryDropLists isCollection.
	self
		assert: presenter addSubqueryToLayoutButton class
		equals: SpButtonPresenter.
	self
		assert: presenter removeSubqueryFromLayoutButton class
		equals: SpButtonPresenter
]

{ #category : #tests }
MiNAryQueryPresenterTest >> testPresentersOnImpossibleQuery [

	self assert: true
]

{ #category : #tests }
MiNAryQueryPresenterTest >> testQueryValidity [

	self assert: true
]
