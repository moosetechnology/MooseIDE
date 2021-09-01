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
	self
		assert: presenter query property
		equals: presenter propertyDropList selectedItem
]

{ #category : #running }
MiPropertyQueryPresenterTest >> queryClass [
	^ self subclassResponsibility
]

{ #category : #tests }
MiPropertyQueryPresenterTest >> testMatchesQuery [

	self
		assert: presenter query property
		equals: presenter propertyDropList selectedItem.
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
		identicalTo: MiNoPossibleQueryPresenter
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
		identicalTo: MiNoPossibleQueryPresenter
]

{ #category : #tests }
MiPropertyQueryPresenterTest >> testQueryMatchesOwnerQuery [

	self assert: presenter query equals: presenter owner query.
	presenter propertyDropList selectIndex: 2.
	self assert: presenter query equals: presenter owner query
]

{ #category : #tests }
MiPropertyQueryPresenterTest >> testQueryValidity [

	self assert: presenter query isValid.

	presenter propertyDropList selectIndex: 2.
	self assert: presenter query isValid.

	self resetPresenterWithEntities: helper noEntities.
	self deny: presenter query isValid
]

{ #category : #tests }
MiPropertyQueryPresenterTest >> testUpdateDoesNotChangeOwnerPresenter [

	presenter propertyDropList selectIndex: 2.
	self
		assert: presenter owner queryConfigurationPresenter
		identicalTo: presenter
]
