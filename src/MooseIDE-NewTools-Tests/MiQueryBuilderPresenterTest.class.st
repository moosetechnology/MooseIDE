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
	#category : #'MooseIDE-NewTools-Tests-Queries Browser'
}

{ #category : #running }
MiQueryBuilderPresenterTest >> application [

	^ MiTestApplication current
]

{ #category : #running }
MiQueryBuilderPresenterTest >> bus [

	^ self application defaultBus
]

{ #category : #running }
MiQueryBuilderPresenterTest >> setUp [

	| helper |
	super setUp.
	helper := FQTestsHelper current.
	browser := MiNewQueriesBrowser openForTests.
	browser selectEntity: helper classesAndMethods.
	presenter := MiQueryBuilderPresenter on: browser
]

{ #category : #running }
MiQueryBuilderPresenterTest >> tearDown [

	browser window ifNotNil: [ :window | window close ].
	self application deleteBus: self bus.
	super tearDown
]

{ #category : #tests }
MiQueryBuilderPresenterTest >> testAddNewChildQueryAction [

	presenter creationPresenters first addNewChildQueryAction.
	self assert: presenter creationPresenters size equals: 2.
	self deny:
		presenter creationPresenters second query parent isRootQuery.
	presenter creationPresenters second addNewChildQueryAction.
	presenter creationPresenters third addNewChildQueryAction.
	self
		assert: presenter creationPresenters last query parentSequence size
		equals: 5.
	self assert: presenter creationPresenters last name equals: 'Q4'
]

{ #category : #tests }
MiQueryBuilderPresenterTest >> testAddNewFirstLevelQuery [

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
MiQueryBuilderPresenterTest >> testCreateFirstQueryForComponentList [

	self assert: presenter creationPresenters size equals: 1.
	self
		assertCollection: presenter componentList presenters
		hasSameElements: presenter creationPresenters
]

{ #category : #tests }
MiQueryBuilderPresenterTest >> testRemoveQueryAction [

	self assert: presenter creationPresenters size equals: 1.
	presenter creationPresenters first addNewChildQueryAction.
	presenter creationPresenters last removeQueryAction.
	self assert: presenter creationPresenters size equals: 1.

	presenter creationPresenters first addNewChildQueryAction.
	presenter creationPresenters second addNewChildQueryAction.
	presenter creationPresenters third addNewChildQueryAction.
	presenter creationPresenters first removeQueryAction.
	self assert: presenter creationPresenters size equals: 0
]

{ #category : #tests }
MiQueryBuilderPresenterTest >> testUpdateComponentList [

	self
		assertCollection: presenter componentList presenters
		hasSameElements: presenter creationPresenters
]
