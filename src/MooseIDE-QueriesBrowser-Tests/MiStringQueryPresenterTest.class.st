Class {
	#name : #MiStringQueryPresenterTest,
	#superclass : #MiComparativeQueryPresenterTest,
	#category : #'MooseIDE-QueriesBrowser-Tests-Queries Configuration'
}

{ #category : #tests }
MiStringQueryPresenterTest >> assertSubpresentersAreConfigured [

	self assert: presenter propertyDropList selectedItem equals: self createNewQuery property.
	self assert: presenter valueInputField text equals: self createNewQuery valueToCompare.
	self assert: presenter comparatorDropList selectedItem equals: self createNewQuery comparator 
]

{ #category : #running }
MiStringQueryPresenterTest >> classToTest [
	^ MiStringQueryPresenter
]

{ #category : #tests }
MiStringQueryPresenterTest >> createNewQuery [

	| rootQuery |
	rootQuery := FQRootQuery new
		result: helper classesAndMethods;
		yourself.
	^ (FQStringQuery defaultForParent: rootQuery)
			comparator: #includesSubstring:;
			property: #name;
			valueToCompare: 'f';
			yourself
]

{ #category : #running }
MiStringQueryPresenterTest >> queryClass [
	^ FQStringQuery
]

{ #category : #running }
MiStringQueryPresenterTest >> setUp [
	super setUp.
	self resetPresenterWithEntities: helper methods
]

{ #category : #running }
MiStringQueryPresenterTest >> valueInput [
	^ 'Server'
]

{ #category : #running }
MiStringQueryPresenterTest >> valueInputClass [
	^ SpTextInputFieldPresenter
]
