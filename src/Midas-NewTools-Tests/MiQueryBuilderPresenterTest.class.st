"
A MiQueryBuilderPresenterTest is a test class for testing the behavior of MiQueryBuilderPresenter
"
Class {
	#name : #MiQueryBuilderPresenterTest,
	#superclass : #TestCase,
	#instVars : [
		'presenter'
	],
	#category : #'Midas-NewTools-Tests-Queries Browser'
}

{ #category : #running }
MiQueryBuilderPresenterTest >> setUp [

	super setUp.

	presenter := MiQueryBuilderPresenter on:
		             (MiNewQueriesBrowser on: MiNewQueriesBrowser newModel)
]

{ #category : #running }
MiQueryBuilderPresenterTest >> tearDown [

	presenter window ifNotNil: [ :window | window close ].

	super tearDown
]

{ #category : #test }
MiQueryBuilderPresenterTest >> testAddNewQueryAction [

	self assert: presenter presentersCollection size equals: 1.
	presenter presentersCollection first addNewQueryAction.
	self assert: presenter presentersCollection size equals: 2
]

{ #category : #test }
MiQueryBuilderPresenterTest >> testCreateFirstQueryForComponentList [

	self assert: presenter presentersCollection size equals: 1.
	self
		assertCollection: presenter componentList presenters
		hasSameElements: presenter presentersCollection
]

{ #category : #test }
MiQueryBuilderPresenterTest >> testRemoveQueryAction [

	self assert: presenter presentersCollection size equals: 1.
	presenter presentersCollection first addNewQueryAction.
	presenter presentersCollection last removeQueryAction.
	self assert: presenter presentersCollection size equals: 1
]

{ #category : #test }
MiQueryBuilderPresenterTest >> testUpdateComponentList [

	self
		assertCollection: presenter componentList presenters
		hasSameElements: presenter presentersCollection
]
