Class {
	#name : #MiQueryConfigurationPresenterTest,
	#superclass : #TestCase,
	#instVars : [
		'helper',
		'presenter',
		'browser'
	],
	#category : #'Midas-NewTools-Tests-Queries Configuration'
}

{ #category : #testing }
MiQueryConfigurationPresenterTest class >> isAbstract [
	^ self == MiQueryConfigurationPresenterTest
]

{ #category : #running }
MiQueryConfigurationPresenterTest >> classToTest [
	^ self subclassResponsibility
]

{ #category : #running }
MiQueryConfigurationPresenterTest >> queryClass [
	^ self subclassResponsibility
]

{ #category : #running }
MiQueryConfigurationPresenterTest >> resetPresenterWithEntities: aMooseGroup [

	| builder superPresenter |
	browser := MiNewQueriesBrowser on: (FQRootQuery new
			            result: aMooseGroup;
			            yourself).
	builder := MiQueryBuilderPresenter on: browser.
	superPresenter := builder componentList items first.
	superPresenter queryTypesDropList selectItem: self queryClass.
	"superPresenter := MiNewQueryCreationPresenter
		                  on: FQRootQuery new
		                  parentPresenter: builder.

	presenter := superPresenter presenters detect: [ :pres | 
		             pres class == self classToTest ]."
	presenter := superPresenter queryConfigurationPresenter
]

{ #category : #running }
MiQueryConfigurationPresenterTest >> setUp [

	super setUp.
	helper := FQTestsHelper current.
	self resetPresenterWithEntities: helper classesAndMethods
]

{ #category : #running }
MiQueryConfigurationPresenterTest >> tearDown [

	browser window ifNotNil: [ :window | window close ].
	MiApplication current deleteBus:
		(MiApplication current busNamed: 'TestBus').
	super tearDown
]

{ #category : #tests }
MiQueryConfigurationPresenterTest >> testImpossibleQueryInitialization [

	self resetPresenterWithEntities: helper noEntities.
	self assert: presenter query class identicalTo: self queryClass.
	self deny: presenter query isValid
]

{ #category : #tests }
MiQueryConfigurationPresenterTest >> testNormalQueryInitialization [
	self assert: presenter query class identicalTo: self queryClass.
	self assert: presenter query isValid
]

{ #category : #tests }
MiQueryConfigurationPresenterTest >> testPresenters [

	self subclassResponsibility
]

{ #category : #tests }
MiQueryConfigurationPresenterTest >> testPresentersOnImpossibleQuery [

	self subclassResponsibility
]

{ #category : #tests }
MiQueryConfigurationPresenterTest >> testQueryValidity [

	^ self subclassResponsibility
]
