Class {
	#name : 'MiStringQueryPresenterTest',
	#superclass : 'MiComparativeQueryPresenterTest',
	#category : 'MooseIDE-QueriesBrowser-Tests-Queries Configuration',
	#package : 'MooseIDE-QueriesBrowser-Tests',
	#tag : 'Queries Configuration'
}

{ #category : 'tests' }
MiStringQueryPresenterTest >> assertSubpresentersAreConfigured [

	self
		assert: self propertyDropList selectedItem
		equals: self createNewQuery property.
	self
		assert: self valueInputField text
		equals: self createNewQuery valueToCompare.
	self
		assert: self comparatorDropList selectedItem
		equals: self createNewQuery comparator
]

{ #category : 'running' }
MiStringQueryPresenterTest >> classToTest [
	^ MiStringQueryPresenter
]

{ #category : 'tests' }
MiStringQueryPresenterTest >> createNewQuery [

	| rootQuery |

	rootQuery := FQRootQuery new
		             input: helper classesAndMethods;
		             yourself.
	^ (FQStringQuery defaultForParent: rootQuery)
		  comparator: #includesSubstring:;
		  property: #name;
		  valueToCompare: 'f';
		  yourself
]

{ #category : 'running' }
MiStringQueryPresenterTest >> queryClass [
	^ FQStringQuery
]

{ #category : 'running' }
MiStringQueryPresenterTest >> setUp [
	super setUp.
	self resetPresenterWithEntities: helper methods
]

{ #category : 'tests' }
MiStringQueryPresenterTest >> testDropListDefaultSelection [


	self assert: self propertyDropList isStartWithSelection.
]

{ #category : 'running' }
MiStringQueryPresenterTest >> valueInput [
	^ 'Server'
]

{ #category : 'running' }
MiStringQueryPresenterTest >> valueInputClass [
	^ SpTextInputFieldPresenter
]
