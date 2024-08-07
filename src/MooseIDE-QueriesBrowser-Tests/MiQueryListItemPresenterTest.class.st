Class {
	#name : #MiQueryListItemPresenterTest,
	#superclass : #MiAbstractApplicationTest,
	#instVars : [
		'presenter',
		'browser',
		'helper'
	],
	#category : #'MooseIDE-QueriesBrowser-Tests-Queries Browser'
}

{ #category : #running }
MiQueryListItemPresenterTest >> bus [

	^ self application defaultBus
]

{ #category : #running }
MiQueryListItemPresenterTest >> setUp [

	| parentPresenter |
	super setUp.

	helper := FQTestsHelper new.
	browser := MiQueriesBrowser openForTests: self application.
	browser receiveEntity: helper classesAndMethods.
	parentPresenter := browser
		                   instantiate: MiQueriesListPresenter
		                   on: browser.

	presenter := MiQueryListItemPresenter
		             on: browser rootQuery
		             owner: parentPresenter
		             queriesListPresenter: parentPresenter.
	presenter setQueryNumber: 1.
	presenter updateQueryConfiguratorPresenterFor: FQStringQuery
]

{ #category : #running }
MiQueryListItemPresenterTest >> tearDown [

	browser window ifNotNil: [ :window | window close ].
	super tearDown
]

{ #category : #tests }
MiQueryListItemPresenterTest >> testAllQueryPresentersExceptSelf [

	self assert: presenter allQueryPresentersExceptSelf size equals: 0.
	presenter queriesListPresenter
		addNewFirstLevelQuery;
		addNewFirstLevelQuery.
	self assert: presenter allQueryPresentersExceptSelf size equals: 2.
	self
		denyCollection: presenter allQueryPresentersExceptSelf
		includesAny: (OrderedCollection with: presenter)
]

{ #category : #tests }
MiQueryListItemPresenterTest >> testConfigureFor [

	| newQuery rootQuery |

	rootQuery := FQRootQuery new
		             input: helper classesAndMethods;
		             yourself.
	newQuery := FQStringQuery defaultForParent: rootQuery.
	newQuery
		comparator: #includesSubstring:;
		property: #name;
		valueToCompare: 'a';
		result.

	presenter configureFor: newQuery.
	self
		assert: presenter queryConfiguratorPresenter class
		equals: newQuery class miPresenterClass
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
	presenter newQueryForClass: FQUnionQuery.

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
		assert: presenter queryConfiguratorPresenter class
		equals: presenter query class miPresenterClass.
	presenter updateQueryConfiguratorPresenterFor: FQStringQuery.
	self assert: presenter query class equals: FQStringQuery.
	self
		assert: presenter queryConfiguratorPresenter class
		equals: presenter query class miPresenterClass.
	presenter updateQueryConfiguratorPresenterFor: FQSubtractionQuery.
	self assert: presenter query class equals: FQSubtractionQuery.
	self
		assert: presenter queryConfiguratorPresenter class
		equals: presenter query class miPresenterClass.
	presenter updateQueryConfiguratorPresenterFor: FQComplementQuery.
	self assert: presenter query class equals: FQComplementQuery.
	self
		assert: presenter queryConfiguratorPresenter class
		equals: presenter query class miPresenterClass
]

{ #category : #tests }
MiQueryListItemPresenterTest >> testUpdateQueryConfiguratorPresenterFor [

	presenter updateQueryConfiguratorPresenterFor: FQBooleanQuery.
	self assert: presenter query class equals: FQBooleanQuery.
	self
		assert: presenter queryConfiguratorPresenter class
		equals: presenter query class miPresenterClass.
	presenter updateQueryConfiguratorPresenterFor: FQStringQuery.
	self assert: presenter query class equals: FQStringQuery.
	self
		assert: presenter queryConfiguratorPresenter class
		equals: presenter query class miPresenterClass.
	presenter updateQueryConfiguratorPresenterFor: FQSubtractionQuery.
	self assert: presenter query class equals: FQSubtractionQuery.
	self
		assert: presenter queryConfiguratorPresenter class
		equals: presenter query class miPresenterClass.
	presenter updateQueryConfiguratorPresenterFor: FQComplementQuery.
	self assert: presenter query class equals: FQComplementQuery.
	self
		assert: presenter queryConfiguratorPresenter class
		equals: presenter query class miPresenterClass
]
