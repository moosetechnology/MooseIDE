Class {
	#name : #MiResultSizeQueryPresenterTest,
	#superclass : #MiQueryConfiguratorPresenterTest,
	#instVars : [
		'innerQuery'
	],
	#category : #'MooseIDE-QueriesBrowser-Tests-Queries Configuration'
}

{ #category : #tests }
MiResultSizeQueryPresenterTest >> assertSubpresentersAreConfigured [

	self assert: presenter subqueriesDropList selectedItem query equals: innerQuery
]

{ #category : #running }
MiResultSizeQueryPresenterTest >> classToTest [

	^ MiResultSizeQueryPresenter
]

{ #category : #tests }
MiResultSizeQueryPresenterTest >> createNewQuery [

	| rootQuery |
	rootQuery := FQRootQuery new
		result: helper classesAndMethods;
		yourself.
	innerQuery := (FQNavigationQuery defaultForParent: rootQuery)
			resetAndChangeDirection: FQIncomingNavigation;
			association: FamixStInvocation;
			yourself.
	browser queriesListPresenter addNewFirstLevelQuery.
	browser queriesListPresenter queryItemsPresenters last configureFor: innerQuery.
	^ FQResultSizeQuery innerQuery: innerQuery comparator: #> valueToCompare: 2
		
]

{ #category : #running }
MiResultSizeQueryPresenterTest >> queryClass [

	^ FQResultSizeQuery
]

{ #category : #running }
MiResultSizeQueryPresenterTest >> resetPresenterWithEntities: aMooseGroup [

	| builder superPresenter |
	browser := MiQueriesBrowser on: (FQRootQuery new
			            result: aMooseGroup;
			            yourself).
	builder := MiQueriesListPresenter on: browser.
	builder
		addNewFirstLevelQuery;
		addNewFirstLevelQuery.
	superPresenter := builder componentList items last.
	superPresenter queryTypesDropList selectItem: self queryClass.
	presenter := superPresenter queryConfiguratorPresenter
]

{ #category : #tests }
MiResultSizeQueryPresenterTest >> testImpossibleQueryInitialization [

	self assert: true
]

{ #category : #tests }
MiResultSizeQueryPresenterTest >> testPresenters [

	self
		assert: presenter subqueriesDropList class
		identicalTo: SpDropListPresenter
]

{ #category : #tests }
MiResultSizeQueryPresenterTest >> testPresentersOnImpossibleQuery [

	"this presenter will not have the impossible query presenter as it only have a droplist to select other queries"

	self assert: true
]

{ #category : #tests }
MiResultSizeQueryPresenterTest >> testQueryValidity [

	"This presenter does not know is the query is valid because it depends on the other queries. You select a query from the droplist and then it computes the value"

	self assert: true
]
