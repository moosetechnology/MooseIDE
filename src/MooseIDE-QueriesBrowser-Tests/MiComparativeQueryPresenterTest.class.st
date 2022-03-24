Class {
	#name : #MiComparativeQueryPresenterTest,
	#superclass : #MiPropertyQueryPresenterTest,
	#category : #'MooseIDE-QueriesBrowser-Tests-Queries Configuration'
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
	
	"Emulate the waiting that the UI has. When the user types something, there is a delay before computing the result."	
	(InputProcessingWaiter delayBeforeProcessing + 100 milliSeconds) wait.
	
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

	self deny: presenter query isValid.

	presenter propertyDropList selectIndex: 2.
	self deny: presenter query isValid.

	presenter comparatorDropList selectIndex: 2.
	self deny: presenter query isValid.

	presenter valueInputField text: self valueInput.
	"The input field has a delay before it processes the change."
	(Delay forSeconds: 1) wait.
	self assert: presenter query isValid.

	self resetPresenterWithEntities: helper noEntities.
	self deny: presenter query isValid
]

{ #category : #running }
MiComparativeQueryPresenterTest >> valueInput [
	^ self subclassResponsibility
]

{ #category : #running }
MiComparativeQueryPresenterTest >> valueInputClass [
	^ self subclassResponsibility
]
