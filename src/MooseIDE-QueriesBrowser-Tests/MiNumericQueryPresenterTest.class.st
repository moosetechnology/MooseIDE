Class {
	#name : #MiNumericQueryPresenterTest,
	#superclass : #MiComparativeQueryPresenterTest,
	#category : #'MooseIDE-QueriesBrowser-Tests-Queries Configuration'
}

{ #category : #tests }
MiNumericQueryPresenterTest >> assertSubpresentersAreConfigured [

	self assert: presenter propertyDropList selectedItem equals: self createNewQuery property.
	self assert: presenter valueInputField number equals: self createNewQuery valueToCompare.
	self assert: presenter comparatorDropList selectedItem equals: self createNewQuery comparator
]

{ #category : #running }
MiNumericQueryPresenterTest >> classToTest [
	^ MiNumericQueryPresenter
]

{ #category : #tests }
MiNumericQueryPresenterTest >> createNewQuery [

	| rootQuery |
	rootQuery := FQRootQuery new
		result: helper classesAndMethods;
		yourself.
	^ (FQNumericQuery defaultForParent: rootQuery)
			property: #fanIn;
			comparator: #>;
			valueToCompare: 5
]

{ #category : #running }
MiNumericQueryPresenterTest >> queryClass [
	^ FQNumericQuery
]

{ #category : #running }
MiNumericQueryPresenterTest >> valueInput [
	^ '5'
]

{ #category : #running }
MiNumericQueryPresenterTest >> valueInputClass [
	^ SpNumberInputFieldPresenter
]
