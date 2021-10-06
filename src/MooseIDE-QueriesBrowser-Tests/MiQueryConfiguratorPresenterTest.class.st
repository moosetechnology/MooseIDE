Class {
	#name : #MiQueryConfiguratorPresenterTest,
	#superclass : #TestCase,
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

{ #category : #running }
MiQueryConfiguratorPresenterTest >> classToTest [
	^ self subclassResponsibility
]

{ #category : #running }
MiQueryConfiguratorPresenterTest >> queryClass [
	^ self subclassResponsibility
]

{ #category : #running }
MiQueryConfiguratorPresenterTest >> resetPresenterWithEntities: aMooseGroup [

	| builder superPresenter |
	browser := MiQueriesBrowser on: (FQRootQuery new
			            result: aMooseGroup;
			            yourself).
	builder := MiQueriesListPresenter on: browser.
	"Add a query presenter"
	builder addNewFirstLevelQuery.
	superPresenter := builder componentList items first.
	superPresenter queryTypesDropList selectItem: self queryClass.
	presenter := superPresenter queryConfiguratorPresenter
]

{ #category : #running }
MiQueryConfiguratorPresenterTest >> setUp [

	super setUp.
	helper := FQTestsHelper current.
	self resetPresenterWithEntities: helper classesAndMethods
]

{ #category : #running }
MiQueryConfiguratorPresenterTest >> tearDown [

	browser window ifNotNil: [ :window | window close ].
	super tearDown
]

{ #category : #tests }
MiQueryConfiguratorPresenterTest >> testImpossibleQueryInitialization [

	self resetPresenterWithEntities: helper noEntities.
	self assert: presenter query class identicalTo: self queryClass.
	self deny: presenter query isValid
]

{ #category : #tests }
MiQueryConfiguratorPresenterTest >> testNormalQueryInitialization [

	self assert: presenter query class identicalTo: self queryClass.
	self assert: presenter query isValid
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
