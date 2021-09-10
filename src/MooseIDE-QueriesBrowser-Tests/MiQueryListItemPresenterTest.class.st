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

	| newQuery lowQuery2 lowQuery1 |
	newQuery := browser rootQuery.
	lowQuery1 := FQStringQuery new.
	lowQuery1 beChildOf: newQuery.
	lowQuery2 := FQBooleanQuery new.
	lowQuery2 beChildOf: lowQuery1.
	self assert: presenter indentationSpacesPresenters size equals: 0.
	presenter parentQuery: lowQuery2.
	self assert: presenter indentationSpacesPresenters size equals: 2
]

{ #category : #tests }
MiQueryListItemPresenterTest >> testName [

	self assert: presenter name equals: 'Q1'
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
