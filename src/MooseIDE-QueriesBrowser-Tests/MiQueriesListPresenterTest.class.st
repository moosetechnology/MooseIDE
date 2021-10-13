"
A MiQueryBuilderPresenterTest is a test class for testing the behavior of MiQueryBuilderPresenter
"
Class {
	#name : #MiQueriesListPresenterTest,
	#superclass : #TestCase,
	#instVars : [
		'presenter',
		'browser'
	],
	#category : #'MooseIDE-QueriesBrowser-Tests-Queries Browser'
}

{ #category : #running }
MiQueriesListPresenterTest >> application [

	^ MiTestApplication current
]

{ #category : #running }
MiQueriesListPresenterTest >> bus [

	^ self application defaultBus
]

{ #category : #running }
MiQueriesListPresenterTest >> setUp [

	| helper |
	super setUp.
	helper := FQTestsHelper current.
	browser := MiQueriesBrowser openForTests.
	browser selectEntity: helper classesAndMethods.
	presenter := MiQueriesListPresenter on: browser
]

{ #category : #running }
MiQueriesListPresenterTest >> tearDown [

	browser window ifNotNil: [ :window | window close ].
	self application deleteBus: self bus.
	super tearDown
]

{ #category : #tests }
MiQueriesListPresenterTest >> testAddNewChildQueryAction [

	presenter addNewFirstLevelQuery.
	presenter addNewChildQueryAction:
		presenter creationPresenters first query.
	self assert: presenter creationPresenters size equals: 2.
	self deny:
		presenter creationPresenters second query parent isRootQuery.
	presenter addNewChildQueryAction:
		presenter creationPresenters second query.
	presenter addNewChildQueryAction:
		presenter creationPresenters third query.
	self
		assert: presenter creationPresenters last query parentSequence size
		equals: 5.
	self assert: presenter creationPresenters last name equals: 'Q4'
]

{ #category : #tests }
MiQueriesListPresenterTest >> testAddNewFirstLevelQuery [

	presenter addNewFirstLevelQuery.
	self assert: presenter creationPresenters size equals: 1.
	presenter
		addNewFirstLevelQuery;
		addNewFirstLevelQuery;
		addNewFirstLevelQuery;
		addNewFirstLevelQuery.
	self assert: presenter creationPresenters size equals: 5.
	self assert: presenter creationPresenters last name equals: 'Q5'.
	presenter creationPresenters do: [ :aPresenter | 
		self assert: aPresenter query parent isRootQuery ]
]

{ #category : #tests }
MiQueriesListPresenterTest >> testRemoveQueryAction [

	presenter addNewFirstLevelQuery.
	presenter addNewChildQueryAction:
		presenter creationPresenters first query.

	presenter removeQueryAction: presenter creationPresenters last.
	self assert: presenter creationPresenters size equals: 1.

	presenter addNewChildQueryAction:
		presenter creationPresenters first query.
	presenter addNewChildQueryAction:
		presenter creationPresenters second query.
	presenter addNewChildQueryAction:
		presenter creationPresenters third query.
	presenter removeQueryAction: presenter creationPresenters first.
	self assert: presenter creationPresenters size equals: 0
]

{ #category : #tests }
MiQueriesListPresenterTest >> testUpdateComponentList [

	self
		assertCollection: presenter componentList presenters
		hasSameElements: presenter creationPresenters.
	presenter addNewFirstLevelQuery.
	self
		assertCollection: presenter componentList presenters
		hasSameElements: presenter creationPresenters.
	presenter addNewChildQueryAction:
		presenter creationPresenters first query.
	self
		assertCollection: presenter componentList presenters
		hasSameElements: presenter creationPresenters
]
