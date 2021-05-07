Class {
	#name : #MiQueryBuilderPresenterTest,
	#superclass : #TestCase,
	#instVars : [
		'builderPresenter'
	],
	#category : #'Midas-NewQueriesBrowser-Tests-Sub presenters'
}

{ #category : #running }
MiQueryBuilderPresenterTest >> setUp [ 
	super setUp.
	builderPresenter :=  (MiQueryBuilderPresenter on: MiNewQueriesBrowser new)
]

{ #category : #test }
MiQueryBuilderPresenterTest >> testAddNewQueryAction [

	builderPresenter presentersCollection first addNewQueryAction.
	self assert: builderPresenter presentersCollection size equals: 2.
	self
		assert: builderPresenter currentQuery
		equals: builderPresenter presentersCollection first query
]

{ #category : #test }
MiQueryBuilderPresenterTest >> testInitializePresenters [

	| presentersClasses |
	presentersClasses := builderPresenter presenters collect: #class.
	self assert: builderPresenter presenters size equals: 2.
	self assert: (presentersClasses includes: MiNewQueriesBrowser).
	self assert: (presentersClasses includes: SpComponentListPresenter).
	self assert: builderPresenter presenters second items size equals: 1.
	self
		assert: builderPresenter presenters second items first class
		equals: MiNewQueryCreationPresenter
]

{ #category : #test }
MiQueryBuilderPresenterTest >> testRemoveQueryAction [

	| queryCreationPresenter |
	queryCreationPresenter := builderPresenter presenters second.
	builderPresenter presentersCollection first addNewQueryAction.
	builderPresenter presentersCollection second removeQueryAction.
	self assert: builderPresenter presentersCollection size equals: 1.
	self assert: queryCreationPresenter items size equals: 1.
	self
		assert: builderPresenter currentQuery
		equals: builderPresenter presentersCollection first query
]
