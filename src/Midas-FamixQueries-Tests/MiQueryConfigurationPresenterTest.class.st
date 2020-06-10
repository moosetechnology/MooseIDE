Class {
	#name : #MiQueryConfigurationPresenterTest,
	#superclass : #SpTest,
	#instVars : [
		'helper'
	],
	#category : #'Midas-FamixQueries-Tests-Presenters'
}

{ #category : #testing }
MiQueryConfigurationPresenterTest class >> isAbstract [
	^ self == FQQueryConfigurationPresenterTest
]

{ #category : #tests }
MiQueryConfigurationPresenterTest >> assertCreationPresenterWasUpdated [
	self
		assertCollection: presenter owner resultList items
		hasSameElements: presenter query result.
	self
		assert: (helper queryFromCodeInPresenter: presenter owner)
		equals: presenter query
]

{ #category : #running }
MiQueryConfigurationPresenterTest >> classToTest [
	^ self subclassResponsibility
]

{ #category : #accessing }
MiQueryConfigurationPresenterTest >> currentQuery [
	^ presenter query
]

{ #category : #running }
MiQueryConfigurationPresenterTest >> openInstance [
	window
		ifNil: [ window := presenter owner
				queryConfigurationPresenter: presenter;
				openWithSpec ]
]

{ #category : #running }
MiQueryConfigurationPresenterTest >> queryClass [
	^ self subclassResponsibility
]

{ #category : #running }
MiQueryConfigurationPresenterTest >> resetPresenterWithEntities: aMooseGroup [
	| superPresenter |
	superPresenter := MiQueryCreationPresenter
		on: (MiQueriesBrowser on: aMooseGroup).
	superPresenter queryTypesDropList selectItem: self queryClass.
	presenter := superPresenter presenters
		detect: [ :pres | pres class == self classToTest ]
]

{ #category : #running }
MiQueryConfigurationPresenterTest >> setUp [
	helper := FQTestsHelper current.
	self resetPresenterWithEntities: helper classesAndMethods
]

{ #category : #tests }
MiQueryConfigurationPresenterTest >> testFirstParameter [
	^ self subclassResponsibility
]

{ #category : #tests }
MiQueryConfigurationPresenterTest >> testImpossibleQueryInitialization [
	self resetPresenterWithEntities: helper noEntities.
	self assert: (presenter query isKindOf: self queryClass).
	self deny: presenter query isValid
]

{ #category : #tests }
MiQueryConfigurationPresenterTest >> testNormalQueryInitialization [
	self assert: (presenter query isKindOf: self queryClass).
	self assert: presenter query isValid
]

{ #category : #tests }
MiQueryConfigurationPresenterTest >> testQueryValidity [
	^ self subclassResponsibility
]

{ #category : #tests }
MiQueryConfigurationPresenterTest >> testSecondParameter [
	^ self subclassResponsibility
]

{ #category : #tests }
MiQueryConfigurationPresenterTest >> testUpdateCreationBrowser [
	^ self subclassResponsibility
]
