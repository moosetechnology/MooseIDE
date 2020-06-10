Class {
	#name : #MiNumericQueryParametersPresenterTest,
	#superclass : #MiComparativeQueryParametersPresenterTest,
	#category : #'Midas-FamixQueries-Tests-SubPresenters'
}

{ #category : #running }
MiNumericQueryParametersPresenterTest >> classToTest [
	^ MiNumericQueryParametersPresenter
]

{ #category : #running }
MiNumericQueryParametersPresenterTest >> queryClass [
	^ FQNumericQuery
]

{ #category : #running }
MiNumericQueryParametersPresenterTest >> valueInput [
	^ '5'
]

{ #category : #running }
MiNumericQueryParametersPresenterTest >> valueInputClass [
	^ SpNumberInputFieldPresenter
]
