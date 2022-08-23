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

	self
		assert: presenter subqueriesDropList selectedItem query
		equals: innerQuery
]

{ #category : #running }
MiResultSizeQueryPresenterTest >> classToTest [

	^ MiResultSizeQueryPresenter
]

{ #category : #tests }
MiResultSizeQueryPresenterTest >> configureInnerQuery [

	| rootQuery |
	rootQuery := FQRootQuery new
		             result: helper classesAndMethods;
		             yourself.
	innerQuery := (FQNavigationQuery defaultForParent: rootQuery)
		              resetAndChangeDirection: FQIncomingNavigation;
		              association: FamixStInvocation;
		              yourself.
	browser queriesListPresenter addNewFirstLevelQuery.
	browser queriesListPresenter queryItemsPresenters last configureFor:
		innerQuery.
	^ innerQuery
]

{ #category : #tests }
MiResultSizeQueryPresenterTest >> createNewQuery [

	self configureInnerQuery.
	^ FQResultSizeQuery
		  innerQuery: innerQuery
		  comparator: #>
		  valueToCompare: 2
]

{ #category : #running }
MiResultSizeQueryPresenterTest >> queryClass [

	^ FQResultSizeQuery
]

{ #category : #running }
MiResultSizeQueryPresenterTest >> resetPresenterWithEntities: aMooseGroup [

	| builder superPresenter |
	browser := MiQueriesBrowser
		           newApplication: MiTestApplication current
		           model: (FQRootQuery new
				            result: aMooseGroup;
				            yourself).
	builder := browser instantiate: MiQueriesListPresenter on: browser.
	builder
		addNewFirstLevelQuery;
		addNewFirstLevelQuery.
	builder componentList items first configureFor:
		self configureInnerQuery.
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

	self configureInnerQuery.
	browser queriesListPresenter componentList items first configureFor:
		innerQuery.
	browser queriesListPresenter updateComponentList.

	self deny: presenter query isValid.

	(presenter presenterAt: #subqueriesDropList) selectIndex: 1.
	self assert:
		(presenter query innerQuery hasSameParametersAs: innerQuery).
	self deny: presenter query isValid.

	(presenter presenterAt: #comparatorDropList) selectIndex: 1.
	self deny: presenter query isValid.

	(presenter presenterAt: #valueInputField) number: 2.
	(Delay forSeconds: 1) wait.
	self assert: presenter query isValid
]
