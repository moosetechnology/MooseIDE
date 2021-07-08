Class {
	#name : #MiNewQueryCreationPresenterTest,
	#superclass : #TestCase,
	#instVars : [
		'presenter',
		'browser'
	],
	#category : #'Midas-NewTools-Tests-Queries Browser'
}

{ #category : #running }
MiNewQueryCreationPresenterTest >> bus [

	^ MiApplication current busNamed: 'TestBus'
]

{ #category : #running }
MiNewQueryCreationPresenterTest >> setUp [

	| parentPresenter helper |
	super setUp.

	helper := FQTestsHelper current.
	browser := MiNewQueriesBrowser runMeFollowing: self bus.
	browser selectEntity: helper classesAndMethods.
	parentPresenter := MiQueryBuilderPresenter on: browser.

	presenter := MiNewQueryCreationPresenter
		             on: FQRootQuery new
		             parentPresenter: parentPresenter.
	presenter updateQueryConfigurationFor: FQStringQuery
]

{ #category : #running }
MiNewQueryCreationPresenterTest >> tearDown [

	browser window ifNotNil: [ :window | window close ].
	MiApplication current deleteBus: self bus.
	super tearDown
]
