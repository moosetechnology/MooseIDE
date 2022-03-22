Class {
	#name : #MiPropertyQueryPresenterTest,
	#superclass : #MiQueryConfiguratorPresenterTest,
	#category : #'MooseIDE-QueriesBrowser-Tests-Queries Configuration'
}

{ #category : #testing }
MiPropertyQueryPresenterTest class >> isAbstract [
	^ self == MiPropertyQueryPresenterTest
]

{ #category : #tests }
MiPropertyQueryPresenterTest >> assertPropertiesDropList [

	self
		assert: presenter propertyDropList class
		identicalTo: SpDropListPresenter.
	self
		assertCollection: presenter propertyDropList listItems
		hasSameElements: presenter query availableProperties.
]

{ #category : #running }
MiPropertyQueryPresenterTest >> queryClass [
	^ self subclassResponsibility
]

{ #category : #tests }
MiPropertyQueryPresenterTest >> testMatchesQuery [

	presenter propertyDropList selectIndex: 2.
	self
		assert: presenter query property
		equals: presenter propertyDropList selectedItem
]

{ #category : #tests }
MiPropertyQueryPresenterTest >> testNoAvailableProperties [

	self resetPresenterWithEntities: helper noEntities.
	self
		assert: presenter propertyDropList class
		identicalTo: NoPossibleQueryPresenter
]

{ #category : #tests }
MiPropertyQueryPresenterTest >> testPresenters [

	self assertPropertiesDropList
]

{ #category : #tests }
MiPropertyQueryPresenterTest >> testPresentersOnImpossibleQuery [

	self resetPresenterWithEntities: helper noEntities.

	self
		assert: presenter propertyDropList class
		identicalTo: NoPossibleQueryPresenter
]

{ #category : #tests }
MiPropertyQueryPresenterTest >> testQueryMatchesOwnerQuery [

	self assert: presenter query equals: presenter owner query.
	presenter propertyDropList selectIndex: 2.
	self assert: presenter query equals: presenter owner query
]

{ #category : #tests }
MiPropertyQueryPresenterTest >> testUpdateDoesNotChangeOwnerPresenter [

	presenter propertyDropList selectIndex: 2.
	self
		assert: presenter owner queryConfiguratorPresenter
		identicalTo: presenter
]
