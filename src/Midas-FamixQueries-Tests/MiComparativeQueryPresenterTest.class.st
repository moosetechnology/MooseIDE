Class {
	#name : #MiComparativeQueryPresenterTest,
	#superclass : #MiPropertyQueryPresenterTest,
	#category : #'Midas-FamixQueries-Tests-QueriesConfiguration'
}

{ #category : #testing }
MiComparativeQueryPresenterTest class >> isAbstract [
	^ self == MiComparativeQueryPresenterTest
]

{ #category : #tests }
MiComparativeQueryPresenterTest >> assertComparatorsDropList [
	self
		assert: presenter comparators class
		identicalTo: SpDropListPresenter.
	self
		assertCollection: presenter comparators listItems
		hasSameElements: presenter query class comparators
]

{ #category : #tests }
MiComparativeQueryPresenterTest >> assertValueInput [
	self
		assert: presenter valueInput class
		identicalTo: self valueInputClass
]

{ #category : #tests }
MiComparativeQueryPresenterTest >> testMatchesQuery [
	super testMatchesQuery.
	presenter comparators selectIndex: 2.
	self
		assert: presenter query comparator
		equals: presenter comparators selectedItem.
	presenter valueInput text: self valueInput.
	self
		assert: presenter query valueToCompare asString
		equals: presenter valueInput text
]

{ #category : #tests }
MiComparativeQueryPresenterTest >> testQueryValidity [
	super testQueryValidity.
	self resetPresenterWithEntities: helper classesAndMethods.
	presenter comparators selectIndex: 2.
	self assert: presenter query isValid.
	presenter valueInput text: self valueInput.
	self assert: presenter query isValid
]

{ #category : #tests }
MiComparativeQueryPresenterTest >> testSecondParameter [
	super testSecondParameter.
	self assertComparatorsDropList.
	self assertValueInput
]

{ #category : #tests }
MiComparativeQueryPresenterTest >> testUpdateCreationBrowser [
	super testUpdateCreationBrowser.
	presenter comparators selectIndex: 2.
	self assertCreationPresenterWasUpdated.
	presenter valueInput text: self valueInput.
	self assertCreationPresenterWasUpdated
]

{ #category : #running }
MiComparativeQueryPresenterTest >> valueInput [
	^ self subclassResponsibility
]

{ #category : #running }
MiComparativeQueryPresenterTest >> valueInputClass [
	^ self subclassResponsibility
]
