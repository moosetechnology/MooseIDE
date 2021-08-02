Class {
	#name : #MiNewQueryCreationPresenterTest,
	#superclass : #TestCase,
	#instVars : [
		'presenter',
		'browser'
	],
	#category : #'MooseIDE-NewTools-Tests-Queries Browser'
}

{ #category : #running }
MiNewQueryCreationPresenterTest >> bus [

	^ MiTestApplication current defaultBus
]

{ #category : #running }
MiNewQueryCreationPresenterTest >> setUp [

	| parentPresenter helper |
	super setUp.

	helper := FQTestsHelper current.
	browser := MiNewQueriesBrowser openForTests.
	browser selectEntity: helper classesAndMethods.
	parentPresenter := MiQueryBuilderPresenter on: browser.

	presenter := MiNewQueryCreationPresenter
		             on: FQRootQuery new
		             parentPresenter: parentPresenter
		             queryNumber: 1.
	presenter updateQueryConfigurationFor: FQStringQuery
]

{ #category : #running }
MiNewQueryCreationPresenterTest >> tearDown [

	browser window ifNotNil: [ :window | window close ].
	super tearDown
]

{ #category : #tests }
MiNewQueryCreationPresenterTest >> testIndentationSpacesPresenters [

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
MiNewQueryCreationPresenterTest >> testName [

	self assert: presenter name equals: 'Q1'
]

{ #category : #tests }
MiNewQueryCreationPresenterTest >> testUpdateQueryConfigurationFor [

	presenter updateQueryConfigurationFor: FQBooleanQuery.
	self assert: presenter query class equals: FQBooleanQuery.
	self
		assert: presenter queryConfigurationPresenter class
		equals: presenter query class miPresenterClass.
	presenter updateQueryConfigurationFor: FQStringQuery.
	self assert: presenter query class equals: FQStringQuery.
	self
		assert: presenter queryConfigurationPresenter class
		equals: presenter query class miPresenterClass.
	presenter updateQueryConfigurationFor: FQSubtractionQuery.
	self assert: presenter query class equals: FQSubtractionQuery.
	self
		assert: presenter queryConfigurationPresenter class
		equals: presenter query class miPresenterClass.
	presenter updateQueryConfigurationFor: FQComplementQuery.
	self assert: presenter query class equals: FQComplementQuery.
	self
		assert: presenter queryConfigurationPresenter class
		equals: presenter query class miPresenterClass
]
