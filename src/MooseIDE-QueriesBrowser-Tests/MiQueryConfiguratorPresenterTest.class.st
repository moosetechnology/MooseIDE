Class {
	#name : #MiQueryConfiguratorPresenterTest,
	#superclass : #MiAbstractApplicationTest,
	#instVars : [
		'helper',
		'presenter',
		'browser'
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

	| builder superPresenter |

	browser := MiQueriesBrowser
		           newApplication: self application
		           model: (FQRootQuery new
				            input: aMooseGroup;
				            yourself).
	builder := browser queriesListPresenter.
	"Add a query presenter"
	builder addNewFirstLevelQuery.
	superPresenter := builder componentList items first.
	superPresenter queryTypesDropList selectItem: self queryClass.
	presenter := superPresenter queryConfiguratorPresenter
]

{ #category : #running }
MiQueryConfiguratorPresenterTest >> setUp [

	super setUp.

	helper := self createTestHelper.

	self resetPresenterWithEntities: helper classesAndMethods
]

{ #category : #running }
MiQueryConfiguratorPresenterTest >> tearDown [

	browser window ifNotNil: [ :window | window close ].
	super tearDown
]

{ #category : #tests }
MiQueryConfiguratorPresenterTest >> testConfigureFor [

	| newQuery |
	browser queriesListPresenter reinitializeQueryPresenters.
	
	newQuery := self createNewQuery.
	
	browser queriesListPresenter addNewFirstLevelQuery.
	browser queriesListPresenter queryItemsPresenters last configureFor: newQuery.
	
	presenter := browser queriesListPresenter queryItemsPresenters last queryConfiguratorPresenter.
	
	self assertSubpresentersAreConfigured.
	self assert: presenter query equals: newQuery
]

{ #category : #tests }
MiQueryConfiguratorPresenterTest >> testConfigureForWithNoEntities [

	| newQuery |
	browser queriesListPresenter reinitializeQueryPresenters.

	newQuery := self createNewQueryWithoutInput.

	browser queriesListPresenter addNewFirstLevelQuery.
	browser queriesListPresenter queryItemsPresenters last configureFor:
		newQuery.

	presenter := browser queriesListPresenter queryItemsPresenters last
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
