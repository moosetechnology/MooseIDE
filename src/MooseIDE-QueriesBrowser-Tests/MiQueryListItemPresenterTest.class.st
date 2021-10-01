Class {
	#name : #MiQueryListItemPresenterTest,
	#superclass : #TestCase,
	#instVars : [
		'presenter',
		'browser'
	],
	#category : #'MooseIDE-QueriesBrowser-Tests-Queries Browser'
}

{ #category : #running }
MiQueryListItemPresenterTest >> bus [

	^ MiTestApplication current defaultBus
]

{ #category : #running }
MiQueryListItemPresenterTest >> setUp [

	| parentPresenter helper |
	super setUp.

	helper := FQTestsHelper current.
	browser := MiQueriesBrowser openForTests.
	browser selectEntity: helper classesAndMethods.
	parentPresenter := MiQueriesListPresenter on: browser.

	presenter := MiQueryListItemPresenter
		             on: FQRootQuery new
		             owner: parentPresenter
		             parentPresenter: parentPresenter.
	presenter setQueryNumber: 1.
	presenter updateQueryConfiguratorPresenterFor: FQStringQuery
]

{ #category : #running }
MiQueryListItemPresenterTest >> tearDown [

	browser window ifNotNil: [ :window | window close ].
	super tearDown
]

{ #category : #tests }
MiQueryListItemPresenterTest >> testIndentationSpacesPresenters [

	| lowQuery2 lowQuery1 complementQuery naryQuery |
	self assert: presenter indentationSpacesPresenters size equals: 0.

	lowQuery1 := FQStringQuery new.
	lowQuery1 beChildOf: browser rootQuery.
	presenter parentQuery: lowQuery1.
	self assert: presenter indentationSpacesPresenters size equals: 1.

	lowQuery2 := FQBooleanQuery new.
	lowQuery2 beChildOf: lowQuery1.
	presenter parentQuery: lowQuery2.
	self assert: presenter indentationSpacesPresenters size equals: 2.

	complementQuery := FQComplementQuery queryToNegate: lowQuery1.
	presenter parentQuery: complementQuery.
	self assert: presenter indentationSpacesPresenters size equals: 1.

	naryQuery := FQNAryQuery subqueries: { lowQuery1. lowQuery2 }.
	presenter parentQuery: naryQuery.
	self assert: presenter indentationSpacesPresenters size equals: 1
]

{ #category : #tests }
MiQueryListItemPresenterTest >> testName [

	self assert: presenter name equals: 'Q1'
]

{ #category : #tests }
MiQueryListItemPresenterTest >> testNewQueryForClass [

	"We check that the method doesn't die when calling it from non unary queries"

	presenter newQueryForClass: FQComplementQuery.
	presenter newQueryForClass: FQNAryQuery.

	self
		assert: (presenter newQueryForClass: FQBooleanQuery) parent
		equals: presenter parentQuery.
	self
		assert: (presenter newQueryForClass: FQScopeQuery) parent
		equals: presenter parentQuery.
	self
		assert: (presenter newQueryForClass: FQNavigationQuery) parent
		equals: presenter parentQuery
]

{ #category : #tests }
MiQueryListItemPresenterTest >> testUpdateQueryConfigurationFor [

	presenter updateQueryConfiguratorPresenterFor: FQBooleanQuery.
	self assert: presenter query class equals: FQBooleanQuery.
	self
		assert: presenter queryConfigurationPresenter class
		equals: presenter query class miPresenterClass.
	presenter updateQueryConfiguratorPresenterFor: FQStringQuery.
	self assert: presenter query class equals: FQStringQuery.
	self
		assert: presenter queryConfigurationPresenter class
		equals: presenter query class miPresenterClass.
	presenter updateQueryConfiguratorPresenterFor: FQSubtractionQuery.
	self assert: presenter query class equals: FQSubtractionQuery.
	self
		assert: presenter queryConfigurationPresenter class
		equals: presenter query class miPresenterClass.
	presenter updateQueryConfiguratorPresenterFor: FQComplementQuery.
	self assert: presenter query class equals: FQComplementQuery.
	self
		assert: presenter queryConfigurationPresenter class
		equals: presenter query class miPresenterClass
]
