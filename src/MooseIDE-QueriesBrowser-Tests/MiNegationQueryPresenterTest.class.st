"
A MiNegationQueryPresenterTest is a test class for testing the behavior of MiNegationQueryPresenter
"
Class {
	#name : #MiNegationQueryPresenterTest,
	#superclass : #MiQueryConfiguratorPresenterTest,
	#instVars : [
		'queryToNegate'
	],
	#category : #'MooseIDE-QueriesBrowser-Tests-Queries Configuration'
}

{ #category : #tests }
MiNegationQueryPresenterTest >> assertSubpresentersAreConfigured [

	self assert: presenter subqueryDropListPresenter selectedItem query equals: queryToNegate
]

{ #category : #running }
MiNegationQueryPresenterTest >> classToTest [

	^ MiNegationQueryPresenter
]

{ #category : #tests }
MiNegationQueryPresenterTest >> createNewQuery [

	| rootQuery |
	rootQuery := FQRootQuery new
		result: helper classesAndMethods;
		yourself.
	queryToNegate := (FQBooleanQuery defaultForParent: rootQuery)
		property: #isStub;
		yourself.
	browser queriesListPresenter addNewFirstLevelQuery.
	browser queriesListPresenter queryItemsPresenters last configureFor: queryToNegate.
	^ FQComplementQuery queryToNegate: queryToNegate
		
]

{ #category : #running }
MiNegationQueryPresenterTest >> queryClass [

	^ FQComplementQuery
]

{ #category : #running }
MiNegationQueryPresenterTest >> resetPresenterWithEntities: aMooseGroup [

	| builder superPresenter |
	browser := MiQueriesBrowser
		           newApplication: MiTestApplication current
		           model: (FQRootQuery new
				            result: aMooseGroup;
				            yourself).
	builder := browser instantiate: MiQueriesListPresenter on: browser.
	builder
		addNewFirstLevelQuery;
		addNewFirstLevelQuery;
		addNewFirstLevelQuery.
	superPresenter := builder componentList items third.
	superPresenter queryTypesDropList selectItem: self queryClass.
	presenter := superPresenter queryConfiguratorPresenter
]

{ #category : #tests }
MiNegationQueryPresenterTest >> testImpossibleQueryInitialization [

	self assert: true
]

{ #category : #tests }
MiNegationQueryPresenterTest >> testIsQueryUsed [

	self assert: (presenter isQueryUsed: presenter subqueryDropListPresenter selectedItem).
	self deny: (presenter isQueryUsed: presenter subqueryDropListPresenter items second)
]

{ #category : #tests }
MiNegationQueryPresenterTest >> testNormalQueryInitialization [

	self assert: presenter query class identicalTo: self queryClass.
	self deny: presenter query isValid.
	presenter query queryToNegate: (FQBooleanQuery new
			 property: #isStub;
			 yourself).
	self assert: presenter query isValid
]

{ #category : #tests }
MiNegationQueryPresenterTest >> testPresenters [

	self
		assert: presenter subqueryDropListPresenter class
		equals: SpDropListPresenter
]

{ #category : #tests }
MiNegationQueryPresenterTest >> testPresentersOnImpossibleQuery [

	"this presenter will not have the impossible query presenter as it only have a droplist to select other queries"

	self assert: true
]

{ #category : #tests }
MiNegationQueryPresenterTest >> testQueryValidity [

	"This presenter does not know is the query is valid because it depends on the other queries. You select a query from the droplist and then it computes the value"

	self assert: true
]
