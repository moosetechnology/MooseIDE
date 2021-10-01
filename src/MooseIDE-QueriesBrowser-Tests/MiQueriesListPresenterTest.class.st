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
		presenter queryItemsPresenters first query.
	self assert: presenter queryItemsPresenters size equals: 2.
	self deny:
		presenter queryItemsPresenters second query parent isRootQuery.

	presenter addNewChildQueryAction:
		presenter queryItemsPresenters second query.
	presenter addNewChildQueryAction:
		presenter queryItemsPresenters third query.
	self
		assert:
		presenter queryItemsPresenters last query parentSequence size
		equals: 4.
	self assert: presenter queryItemsPresenters last name equals: 'Q4'.

	"Check if the child query is added in the right place"
	presenter addNewChildQueryAction:
		presenter queryItemsPresenters first query.
	self assert: presenter queryItemsPresenters second name equals: 'Q5'
]

{ #category : #tests }
MiQueriesListPresenterTest >> testAddNewFirstLevelQuery [

	presenter addNewFirstLevelQuery.
	self assert: presenter queryItemsPresenters size equals: 1.

	presenter
		addNewFirstLevelQuery;
		addNewFirstLevelQuery;
		addNewFirstLevelQuery;
		addNewFirstLevelQuery.
	self assert: presenter queryItemsPresenters size equals: 5.
	self assert: presenter queryItemsPresenters last name equals: 'Q5'.

	presenter queryItemsPresenters do: [ :aPresenter | 
		self assert: aPresenter query parent isRootQuery ]
]

{ #category : #tests }
MiQueriesListPresenterTest >> testRemoveQueryAction [

	presenter addNewFirstLevelQuery.
	presenter addNewChildQueryAction:
		presenter queryItemsPresenters first query.

	presenter removeQueryAction: presenter queryItemsPresenters last.
	self assert: presenter queryItemsPresenters size equals: 1.

	presenter addNewChildQueryAction:
		presenter queryItemsPresenters first query.
	presenter addNewChildQueryAction:
		presenter queryItemsPresenters second query.
	presenter addNewChildQueryAction:
		presenter queryItemsPresenters third query.
	presenter removeQueryAction: presenter queryItemsPresenters first.
	self assert: presenter queryItemsPresenters size equals: 0
]

{ #category : #tests }
MiQueriesListPresenterTest >> testUpdateComponentList [

	self
		assertCollection: presenter componentList presenters
		hasSameElements: presenter queryItemsPresenters.
	presenter addNewFirstLevelQuery.
	self
		assertCollection: presenter componentList presenters
		hasSameElements: presenter queryItemsPresenters.
	presenter addNewChildQueryAction:
		presenter queryItemsPresenters first query.
	self
		assertCollection: presenter componentList presenters
		hasSameElements: presenter queryItemsPresenters
]
