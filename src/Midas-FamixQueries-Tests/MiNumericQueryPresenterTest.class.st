Class {
	#name : #MiNumericQueryPresenterTest,
	#superclass : #MiComparativeQueryPresenterTest,
	#category : #'Midas-FamixQueries-Tests-QueriesConfiguration'
}

{ #category : #running }
MiNumericQueryPresenterTest >> classToTest [
	^ MiNumericQueryPresenter
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
