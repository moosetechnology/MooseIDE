Class {
	#name : 'MiPropertyQueryPresenterTest',
	#superclass : 'MiQueryConfiguratorPresenterTest',
	#category : 'MooseIDE-QueriesBrowser-Tests-Queries Configuration',
	#package : 'MooseIDE-QueriesBrowser-Tests',
	#tag : 'Queries Configuration'
}

{ #category : 'testing' }
MiPropertyQueryPresenterTest class >> isAbstract [
	^ self == MiPropertyQueryPresenterTest
]

{ #category : 'tests' }
MiPropertyQueryPresenterTest >> assertPropertiesDropList [

	self
		assert: self propertyDropList class
		identicalTo: SpDropListPresenter.
	self
		assertCollection: self propertyDropList listItems
		hasSameElements: presenter query availableProperties
]

{ #category : 'accessing-subpresenters' }
MiPropertyQueryPresenterTest >> propertyDropList [

	^ presenter presenterAt: #propertyDropList
]

{ #category : 'running' }
MiPropertyQueryPresenterTest >> queryClass [
	^ self subclassResponsibility
]

{ #category : 'tests' }
MiPropertyQueryPresenterTest >> testMatchesQuery [

	self propertyDropList selectIndex: 2.
	self
		assert: presenter query property
		equals: self propertyDropList selectedItem
]

{ #category : 'tests' }
MiPropertyQueryPresenterTest >> testNoAvailableProperties [

	self resetPresenterWithEntities: helper noEntities.
	self
		assert: self propertyDropList class
		identicalTo: NoPossibleQueryPresenter
]

{ #category : 'tests' }
MiPropertyQueryPresenterTest >> testPresenters [

	self assertPropertiesDropList
]

{ #category : 'tests' }
MiPropertyQueryPresenterTest >> testPresentersOnImpossibleQuery [

	self resetPresenterWithEntities: helper noEntities.

	self
		assert: self propertyDropList class
		identicalTo: NoPossibleQueryPresenter
]

{ #category : 'tests' }
MiPropertyQueryPresenterTest >> testQueryMatchesOwnerQuery [

	self assert: presenter query equals: presenter owner query.
	self propertyDropList selectIndex: 2.
	self assert: presenter query equals: presenter owner query
]

{ #category : 'tests' }
MiPropertyQueryPresenterTest >> testUpdateDoesNotChangeOwnerPresenter [

	self propertyDropList selectIndex: 2.
	self
		assert: presenter owner queryConfiguratorPresenter
		identicalTo: presenter
]
