Class {
	#name : #MiNavigationQueryPresenterTest,
	#superclass : #MiQueryConfigurationPresenterTest,
	#category : #'Midas-NewTools-Tests-Queries Configuration'
}

{ #category : #running }
MiNavigationQueryPresenterTest >> classToTest [
	^ MiNavigationQueryPresenter
]

{ #category : #running }
MiNavigationQueryPresenterTest >> queryClass [
	^ FQNavigationQuery
]

{ #category : #tests }
MiNavigationQueryPresenterTest >> testPresenters [

	self
		assert: presenter directionDropList class
		equals: SpDropListPresenter.
	self
		assertCollection: presenter directionDropList items
		hasSameElements: presenter query class directionStrategies.
	self
		assert: presenter associationsButton class
		equals: SpButtonPresenter.
	self
		assert: presenter associationsList class
		equals: SpFilteringSelectableListPresenter.
	self
		assertCollection: presenter associationsList items
		hasSameElements: presenter query availableAssociations
]

{ #category : #tests }
MiNavigationQueryPresenterTest >> testPresentersOnImpossibleQuery [

	self resetPresenterWithEntities: helper noEntities.

	self
		assert: presenter directionDropList class
		equals: SpDropListPresenter.
	self
		assert: presenter associationsButton class
		identicalTo: MiNoPossibleQueryPresenter
]

{ #category : #tests }
MiNavigationQueryPresenterTest >> testQueryValidity [

	self assert: presenter query isValid.
	self resetPresenterWithEntities:
		helper entitiesWithNoIncomingAssociations.
	self deny: presenter query isValid.
	self resetPresenterWithEntities: helper noEntities.
	self deny: presenter query isValid
]

{ #category : #tests }
MiNavigationQueryPresenterTest >> testUpdateQueryWithSelectedAssociations [

	| associationsRemoved |
	associationsRemoved := presenter query availableAssociations 
		                       removeFirst: 2.
	presenter updateQueryWithSelectedAssociations: associationsRemoved.
	self
		assertCollection: presenter query associations
		hasSameElements: associationsRemoved
]
