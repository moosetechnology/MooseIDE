Class {
	#name : #MiComparativeQueryParametersPresenterTest,
	#superclass : #MiPropertyQueryParametersPresenterTest,
	#category : #'Midas-FamixQueries-Tests-SubPresenters'
}

{ #category : #testing }
MiComparativeQueryParametersPresenterTest class >> isAbstract [
	^ self == MiComparativeQueryParametersPresenterTest
]

{ #category : #tests }
MiComparativeQueryParametersPresenterTest >> testComparatorsDropList [
	self
		assert: presenter comparators class
		identicalTo: SpDropListPresenter.
	self
		assertCollection: presenter comparators listItems
		hasSameElements: presenter query class comparators
]

{ #category : #tests }
MiComparativeQueryParametersPresenterTest >> testMatchesQuery [
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
MiComparativeQueryParametersPresenterTest >> testQueryValidity [
	super testQueryValidity.
	presenter comparators selectIndex: 2.
	self assert: presenter query isValid.
	presenter valueInput text: self valueInput.
	self assert: presenter query isValid
]

{ #category : #tests }
MiComparativeQueryParametersPresenterTest >> testUpdateCreationBrowser [
	super testUpdateCreationBrowser.
	presenter comparators selectIndex: 2.
	self assertCreationPresenterWasUpdated.
	presenter valueInput text: self valueInput.
	self assertCreationPresenterWasUpdated
]

{ #category : #tests }
MiComparativeQueryParametersPresenterTest >> testValueInput [
	self
		assert: presenter valueInput class
		identicalTo: self valueInputClass
]

{ #category : #running }
MiComparativeQueryParametersPresenterTest >> valueInput [
	^ self subclassResponsibility
]

{ #category : #running }
MiComparativeQueryParametersPresenterTest >> valueInputClass [
	^ self subclassResponsibility
]
