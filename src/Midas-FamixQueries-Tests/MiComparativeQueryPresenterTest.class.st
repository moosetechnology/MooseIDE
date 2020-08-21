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
		assert: presenter comparatorDropList class
		identicalTo: SpDropListPresenter.
	self
		assertCollection: presenter comparatorDropList listItems
		hasSameElements: presenter query class comparators
]

{ #category : #tests }
MiComparativeQueryPresenterTest >> assertValueInputField [

	self
		assert: presenter valueInputField class
		identicalTo: self valueInputClass
]

{ #category : #tests }
MiComparativeQueryPresenterTest >> testMatchesQuery [

	super testMatchesQuery.
	presenter comparatorDropList selectIndex: 2.
	self
		assert: presenter query comparator
		equals: presenter comparatorDropList selectedItem.
	presenter valueInputField text: self valueInput.
	self
		assert: presenter query valueToCompare asString
		equals: presenter valueInputField text
]

{ #category : #tests }
MiComparativeQueryPresenterTest >> testPresenters [

	super testPresenters.
	self
		assertComparatorsDropList;
		assertValueInputField
]

{ #category : #tests }
MiComparativeQueryPresenterTest >> testPresentersOnImpossibleQuery [

	super testPresentersOnImpossibleQuery.

	self
		assert: presenter comparatorDropList class
		identicalTo: SpNullPresenter.

	self
		assert: presenter valueInputField class
		identicalTo: SpNullPresenter
]

{ #category : #tests }
MiComparativeQueryPresenterTest >> testQueryValidity [

	super testQueryValidity.

	self resetPresenterWithEntities: helper classesAndMethods.

	presenter comparatorDropList selectIndex: 2.
	self assert: presenter query isValid.

	presenter valueInputField text: self valueInput.
	self assert: presenter query isValid
]

{ #category : #tests }
MiComparativeQueryPresenterTest >> testUpdateCreationBrowser [

	super testUpdateCreationBrowser.
	presenter comparatorDropList selectIndex: 2.
	self assertCreationPresenterWasUpdated.
	presenter valueInputField text: self valueInput.
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
