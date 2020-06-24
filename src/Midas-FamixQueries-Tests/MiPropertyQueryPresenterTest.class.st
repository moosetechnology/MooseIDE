Class {
	#name : #MiPropertyQueryPresenterTest,
	#superclass : #MiQueryConfigurationPresenterTest,
	#category : #'Midas-FamixQueries-Tests-QueriesConfiguration'
}

{ #category : #testing }
MiPropertyQueryPresenterTest class >> isAbstract [
	^ self == MiPropertyQueryPresenterTest
]

{ #category : #tests }
MiPropertyQueryPresenterTest >> assertPropertiesDropList [
	self
		assert: presenter properties class
		identicalTo: SpDropListPresenter.
	self
		assertCollection: presenter properties listItems
		hasSameElements: presenter query availableProperties.
	self
		assert: presenter query property
		equals: presenter properties selectedItem
]

{ #category : #running }
MiPropertyQueryPresenterTest >> queryClass [
	^ self subclassResponsibility
]

{ #category : #tests }
MiPropertyQueryPresenterTest >> testFirstParameter [
	self
		assert: presenter firstParameter class
		identicalTo: SpNullPresenter.
		
	self resetPresenterWithEntities: helper noEntities.
	self
		assert: presenter firstParameter class
		identicalTo: SpNullPresenter.
]

{ #category : #tests }
MiPropertyQueryPresenterTest >> testMatchesQuery [
	self
		assert: presenter query property
		equals: presenter properties selectedItem.
	presenter properties selectIndex: 2.
	self
		assert: presenter query property
		equals: presenter properties selectedItem
]

{ #category : #tests }
MiPropertyQueryPresenterTest >> testNoAvailableProperties [
	self resetPresenterWithEntities: helper noEntities.
	self
		assert: presenter secondParameter class
		identicalTo: MiNoPossibleQueryPresenter
]

{ #category : #tests }
MiPropertyQueryPresenterTest >> testQueryMatchesOwnerQuery [
	self assert: presenter query equals: presenter owner query.
	presenter properties selectIndex: 2.
	self assert: presenter query equals: presenter owner query
]

{ #category : #tests }
MiPropertyQueryPresenterTest >> testQueryValidity [
	self assert: self currentQuery isValid.
	presenter properties selectIndex: 2.
	self assert: self currentQuery isValid.

	self resetPresenterWithEntities: helper noEntities.
	self deny: presenter query isValid
]

{ #category : #tests }
MiPropertyQueryPresenterTest >> testSecondParameter [
	self assertPropertiesDropList.
]

{ #category : #tests }
MiPropertyQueryPresenterTest >> testUpdateCreationBrowser [
	self assertCreationPresenterWasUpdated.
	presenter properties selectIndex: 2.
	self assertCreationPresenterWasUpdated
]

{ #category : #tests }
MiPropertyQueryPresenterTest >> testUpdateDoesNotChangeOwnerPresenter [
	presenter properties selectIndex: 2.
	self
		assert: presenter owner queryConfigurationPresenter
		identicalTo: presenter
]
