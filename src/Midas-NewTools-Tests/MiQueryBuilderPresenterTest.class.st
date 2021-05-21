"
A MiQueryBuilderPresenterTest is a test class for testing the behavior of MiQueryBuilderPresenter
"
Class {
	#name : #MiQueryBuilderPresenterTest,
	#superclass : #TestCase,
	#instVars : [
		'presenter',
		'browser'
	],
	#category : #'Midas-NewTools-Tests-Queries Browser'
}

{ #category : #running }
MiQueryBuilderPresenterTest >> application [

	^ MiApplication current
]

{ #category : #running }
MiQueryBuilderPresenterTest >> bus [

	^ self application busNamed: 'TestBus'
]

{ #category : #running }
MiQueryBuilderPresenterTest >> setUp [

	| helper |
	super setUp.
	helper := FQTestsHelper current.
	browser := MiNewQueriesBrowser runMeFollowing: self bus.
	browser selectEntity: helper classesAndMethods.
	presenter := MiQueryBuilderPresenter on: browser
]

{ #category : #running }
MiQueryBuilderPresenterTest >> tearDown [

	browser window ifNotNil: [ :window | window close ].
	self application deleteBus: self bus.
	super tearDown
]

{ #category : #test }
MiQueryBuilderPresenterTest >> testAddNewQueryAction [

	self assert: presenter presentersCollection size equals: 1.
	presenter presentersCollection first addNewQueryAction.
	self assert: presenter presentersCollection size equals: 2
]

{ #category : #test }
MiQueryBuilderPresenterTest >> testRemoveQueryAction [

	self assert: presenter presentersCollection size equals: 1.
	presenter presentersCollection first addNewQueryAction.
	presenter presentersCollection last removeQueryAction.
	self assert: presenter presentersCollection size equals: 1
]
