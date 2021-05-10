"
A MiNewQueryCreationPresenterTest is a test class for testing the behavior of MiNewQueryCreationPresenter
"
Class {
	#name : #MiNewQueryCreationPresenterTest,
	#superclass : #TestCase,
	#instVars : [
		'creationPresenter'
	],
	#category : #'Midas-NewQueriesBrowser-Tests-Sub presenters'
}

{ #category : #running }
MiNewQueryCreationPresenterTest >> setUp [

	| queriesBrowser queryBuilderPresenter |
	super setUp.

	queriesBrowser := MiNewQueriesBrowser new.
	queryBuilderPresenter := MiQueryBuilderPresenter on: queriesBrowser.
	creationPresenter := MiNewQueryCreationPresenter on:
		                     queryBuilderPresenter
]

{ #category : #test }
MiNewQueryCreationPresenterTest >> testAddNewQueryAction [

	| builderPresenter |
	builderPresenter := creationPresenter parentPresenter.
	self assert: builderPresenter presentersCollection size equals: 1.
	creationPresenter addNewQueryAction.
	self assert: builderPresenter presentersCollection size equals: 2
]

{ #category : #test }
MiNewQueryCreationPresenterTest >> testDisable [

	self flag: #toImplement.
	self assert: true
]

{ #category : #test }
MiNewQueryCreationPresenterTest >> testEnable [

	self flag: #toImplement.
	self assert: true
]

{ #category : #test }
MiNewQueryCreationPresenterTest >> testOpen [

	| window |
	window := creationPresenter openWithSpec.
	self assert: window isBuilt.
	window close
]

{ #category : #test }
MiNewQueryCreationPresenterTest >> testQueryTypes [

	self
		assertCollection: creationPresenter class queryTypes
		hasSameElements:
		(FQUnaryQuery allSubclasses select: #canBeConfigured)
]

{ #category : #test }
MiNewQueryCreationPresenterTest >> testRemoveQueryAction [

	| builderPresenter |
	creationPresenter
		addNewQueryAction;
		removeQueryAction.
	builderPresenter := creationPresenter parentPresenter.
	self assert: builderPresenter presentersCollection size equals: 1
]

{ #category : #test }
MiNewQueryCreationPresenterTest >> testUpdateQueryConfigurationFor [

	| queryTypesAssociations |
	queryTypesAssociations := { 
		                          (MiNavigationQueryPresenter
		                           -> FQNavigationQuery).
		                          (MiScopeQueryPresenter -> FQScopeQuery).
		                          (MiTypeQueryPresenter -> FQTypeQuery).
		                          (MiBooleanQueryPresenter -> FQBooleanQuery).
		                          (MiNumericQueryPresenter -> FQNumericQuery).
		                          (MiStringQueryPresenter -> FQStringQuery) }.
	queryTypesAssociations do: [ :association | 
		creationPresenter updateQueryConfigurationFor: association value.
		self
			assert: creationPresenter queryConfigurationPresenter class
			equals: association key ]
]
