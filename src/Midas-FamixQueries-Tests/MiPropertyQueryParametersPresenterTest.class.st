Class {
	#name : #MiPropertyQueryParametersPresenterTest,
	#superclass : #SpTest,
	#instVars : [
		'helper'
	],
	#category : #'Midas-FamixQueries-Tests-SubPresenters'
}

{ #category : #testing }
MiPropertyQueryParametersPresenterTest class >> isAbstract [
	^ self == FQPropertyQueryParametersPresenterTest
]

{ #category : #tests }
MiPropertyQueryParametersPresenterTest >> assertCreationPresenterWasUpdated [
	self
		assertCollection: presenter owner owner resultList items
		hasSameElements: presenter owner query result.
	self
		assert: (helper queryFromCodeInPresenter: presenter owner owner)
		equals: presenter owner query
]

{ #category : #running }
MiPropertyQueryParametersPresenterTest >> queryClass [
	^ self subclassResponsibility
]

{ #category : #running }
MiPropertyQueryParametersPresenterTest >> setUp [
	| superPresenter |
	helper := FQTestsHelper current.
	superPresenter := MiQueryCreationPresenter
		on: (MiQueriesBrowser on: helper modelExample allBehaviourals).
	superPresenter updateQueryConfigurationFor: FQPropertyQuery.
	(superPresenter queryConfigurationPresenter firstParameter presenters
		detect:
			[ :radioButton | radioButton label = self queryClass label substrings first ])
		click.
	presenter := superPresenter queryConfigurationPresenter
		secondParameter
]

{ #category : #tests }
MiPropertyQueryParametersPresenterTest >> testMatchesQuery [
	self
		assert: presenter query property
		equals: presenter properties selectedItem.
	presenter properties selectIndex: 2.
	self
		assert: presenter query property
		equals: presenter properties selectedItem
]

{ #category : #tests }
MiPropertyQueryParametersPresenterTest >> testNormalQueryInitialization [
	self assert: presenter query class identicalTo: self queryClass.
	self assert: presenter query isValid
]

{ #category : #tests }
MiPropertyQueryParametersPresenterTest >> testPropertiesDropList [
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

{ #category : #tests }
MiPropertyQueryParametersPresenterTest >> testQueryMatchesOwnerQuery [
	self assert: presenter query equals: presenter owner query.
	presenter properties selectIndex: 2.
	self assert: presenter query equals: presenter owner query
]

{ #category : #tests }
MiPropertyQueryParametersPresenterTest >> testQueryValidity [
	self assert: presenter query isValid.
	presenter properties selectIndex: 2.
	self assert: presenter query isValid
]

{ #category : #tests }
MiPropertyQueryParametersPresenterTest >> testUpdateCreationBrowser [
	self assertCreationPresenterWasUpdated.
	presenter properties selectIndex: 2.
	self assertCreationPresenterWasUpdated
]

{ #category : #tests }
MiPropertyQueryParametersPresenterTest >> testUpdateDoesNotChangeOwnerPresenter [
	presenter properties selectIndex: 2.
	self assert: presenter owner secondParameter identicalTo: presenter
]
