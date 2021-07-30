Class {
	#name : #MiTypeQueryPresenterTest,
	#superclass : #MiQueryConfigurationPresenterTest,
	#category : #'MooseIDE-NewTools-Tests-Queries Configuration'
}

{ #category : #running }
MiTypeQueryPresenterTest >> classToTest [
	^ MiTypeQueryPresenter
]

{ #category : #running }
MiTypeQueryPresenterTest >> queryClass [
	^ FQTypeQuery
]

{ #category : #tests }
MiTypeQueryPresenterTest >> testPresenters [

	self assert: presenter typesButton class equals: SpButtonPresenter.
	self
		assert: presenter typesList class
		equals: SpFilteringSelectableListPresenter.
	self
		assert: presenter typesList items
		equals: presenter query availableTypes
]

{ #category : #tests }
MiTypeQueryPresenterTest >> testPresentersOnImpossibleQuery [

	self resetPresenterWithEntities: helper noEntities.
	self
		assert: presenter typesButton class
		identicalTo: MiNoPossibleQueryPresenter
]

{ #category : #tests }
MiTypeQueryPresenterTest >> testQueryValidity [

	self assert: presenter query isValid.
	self resetPresenterWithEntities: helper noEntities.
	self deny: presenter query isValid
]

{ #category : #test }
MiTypeQueryPresenterTest >> testUpdateQueryWithSelectedTypes [

	| typesRemoved |
	typesRemoved := presenter query availableTypes removeFirst: 2.
	presenter updateQueryWithSelectedTypes: typesRemoved.
	self
		assertCollection: presenter query types
		hasSameElements: typesRemoved
]
