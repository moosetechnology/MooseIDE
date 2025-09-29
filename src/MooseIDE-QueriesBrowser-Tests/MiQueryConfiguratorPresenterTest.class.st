Class {
	#name : #MiQueryConfiguratorPresenterTest,
	#superclass : #MiAbstractApplicationTest,
	#instVars : [
		'helper',
		'presenter',
		'browser',
		'queriesListPresenter'
	],
	#category : #'MooseIDE-QueriesBrowser-Tests-Queries Configuration'
}

{ #category : #testing }
MiQueryConfiguratorPresenterTest class >> isAbstract [
	^ self == MiQueryConfiguratorPresenterTest
]

{ #category : #tests }
MiQueryConfiguratorPresenterTest >> assertSubpresentersAreConfigured [

	self subclassResponsibility
]

{ #category : #running }
MiQueryConfiguratorPresenterTest >> classToTest [
	^ self subclassResponsibility
]

{ #category : #tests }
MiQueryConfiguratorPresenterTest >> createNewQuery [

	self subclassResponsibility
]

{ #category : #tests }
MiQueryConfiguratorPresenterTest >> createNewQueryWithoutInput [

	^ self createNewQuery
		  parent: FQRootQuery new;
		  yourself
]

{ #category : #running }
MiQueryConfiguratorPresenterTest >> createTestHelper [
	^FQTestsHelper new
]

{ #category : #running }
MiQueryConfiguratorPresenterTest >> queryClass [
	^ self subclassResponsibility
]

{ #category : #running }
MiQueryConfiguratorPresenterTest >> resetPresenterWithEntities: aMooseGroup [

	| superPresenter |
	browser followEntity: aMooseGroup.

	"Add a query presenter"
	queriesListPresenter addNewFirstLevelQuery.
	superPresenter := queriesListPresenter componentList items first.
	superPresenter queryTypesDropList selectItem: self queryClass.
	presenter := superPresenter queryConfiguratorPresenter
]

{ #category : #running }
MiQueryConfiguratorPresenterTest >> setUp [

	super setUp.

	helper := self createTestHelper.
	browser := MiQueriesBrowser
		           newApplication: self application
		           model: MiQueriesModel new.
	queriesListPresenter := browser presenterAt: #queriesListPresenter.
	self resetPresenterWithEntities: helper classesAndMethods
]

{ #category : #running }
MiQueryConfiguratorPresenterTest >> tearDown [

	browser ifNotNil: [ browser withWindowDo: [ :window | window close ] ].
	super tearDown
]

{ #category : #tests }
MiQueryConfiguratorPresenterTest >> testConfigureFor [

	| newQuery |
	queriesListPresenter reinitializeQueryPresenters.

	newQuery := self createNewQuery.

	queriesListPresenter addNewFirstLevelQuery.
	queriesListPresenter queryItemsPresenters last configureFor: newQuery.

	presenter := queriesListPresenter queryItemsPresenters last
		             queryConfiguratorPresenter.

	self assertSubpresentersAreConfigured.
	self assert: presenter query equals: newQuery
]

{ #category : #tests }
MiQueryConfiguratorPresenterTest >> testConfigureForWithNoEntities [

	| newQuery |
	queriesListPresenter reinitializeQueryPresenters.

	newQuery := self createNewQueryWithoutInput.

	queriesListPresenter addNewFirstLevelQuery.
	queriesListPresenter queryItemsPresenters last configureFor: newQuery.

	presenter := queriesListPresenter queryItemsPresenters last
		             queryConfiguratorPresenter.

	self assertSubpresentersAreConfigured.
	self assert: presenter query equals: newQuery
]

{ #category : #tests }
MiQueryConfiguratorPresenterTest >> testImpossibleQueryInitialization [

	self resetPresenterWithEntities: helper noEntities.
	self assert: presenter query class identicalTo: self queryClass.
	self deny: presenter query isValid
]

{ #category : #tests }
MiQueryConfiguratorPresenterTest >> testIsQueryUsed [

	self deny: (presenter isQueryUsed: FQBooleanQuery new)
]

{ #category : #tests }
MiQueryConfiguratorPresenterTest >> testNormalQueryInitialization [

	self assert: presenter query class identicalTo: self queryClass.
	self flag: 'Remove this next line: a query now may be invalid'
	"self assert: presenter query isValid"
]

{ #category : #tests }
MiQueryConfiguratorPresenterTest >> testPresenters [

	self subclassResponsibility
]

{ #category : #tests }
MiQueryConfiguratorPresenterTest >> testPresentersOnImpossibleQuery [

	self subclassResponsibility
]

{ #category : #tests }
MiQueryConfiguratorPresenterTest >> testQueryValidity [

	^ self subclassResponsibility
]
