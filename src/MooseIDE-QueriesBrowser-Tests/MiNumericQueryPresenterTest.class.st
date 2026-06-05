Class {
	#name : 'MiNumericQueryPresenterTest',
	#superclass : 'MiComparativeQueryPresenterTest',
	#category : 'MooseIDE-QueriesBrowser-Tests-Queries Configuration',
	#package : 'MooseIDE-QueriesBrowser-Tests',
	#tag : 'Queries Configuration'
}

{ #category : 'tests' }
MiNumericQueryPresenterTest >> assertSubpresentersAreConfigured [

	self
		assert: self propertyDropList selectedItem
		equals: self createNewQuery property.
	self
		assert: self valueInputField number
		equals: self createNewQuery valueToCompare.
	self
		assert: self comparatorDropList selectedItem
		equals: self createNewQuery comparator
]

{ #category : 'running' }
MiNumericQueryPresenterTest >> classToTest [
	^ MiNumericQueryPresenter
]

{ #category : 'tests' }
MiNumericQueryPresenterTest >> createNewQuery [

	| rootQuery |

	rootQuery := FQRootQuery new
		             input: helper classesAndMethods;
		             yourself.
	^ (FQNumericQuery defaultForParent: rootQuery)
		  property: #fanIn;
		  comparator: #>;
		  valueToCompare: 5
]

{ #category : 'running' }
MiNumericQueryPresenterTest >> queryClass [
	^ FQNumericQuery
]

{ #category : 'running' }
MiNumericQueryPresenterTest >> valueInput [
	^ '5'
]

{ #category : 'running' }
MiNumericQueryPresenterTest >> valueInputClass [
	^ SpNumberInputFieldPresenter
]
