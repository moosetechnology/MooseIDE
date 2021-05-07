"
A MiQueryConfigurationPresenterFactoryTest is a test class for testing the behavior of MiQueryConfigurationPresenterFactory
"
Class {
	#name : #QueryConfigurationPresenterFactoryTest,
	#superclass : #TestCase,
	#instVars : [
		'factoryClass'
	],
	#category : #'Midas-NewQueriesBrowser-Tests-Factories'
}

{ #category : #running }
QueryConfigurationPresenterFactoryTest >> setUp [

	super setUp.
	factoryClass := QueryConfigurationPresenterFactory
]

{ #category : #tests }
QueryConfigurationPresenterFactoryTest >> testPresenterClassForQuery [

	self
		assert: (factoryClass presenterClassForQuery: FQNavigationQuery)
		equals: MiNavigationQueryPresenter.
	self
		assert: (factoryClass presenterClassForQuery: FQBooleanQuery)
		equals: MiBooleanQueryPresenter.
	self
		assert: (factoryClass presenterClassForQuery: FQNumericQuery)
		equals: MiNumericQueryPresenter.
	self
		assert: (factoryClass presenterClassForQuery: FQStringQuery)
		equals: MiStringQueryPresenter.
	self
		assert: (factoryClass presenterClassForQuery: FQScopeQuery)
		equals: MiScopeQueryPresenter.
	self
		assert: (factoryClass presenterClassForQuery: FQTypeQuery)
		equals: MiTypeQueryPresenter
]
