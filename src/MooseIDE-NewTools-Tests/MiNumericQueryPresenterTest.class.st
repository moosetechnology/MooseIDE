Class {
	#name : #MiNumericQueryPresenterTest,
	#superclass : #MiComparativeQueryPresenterTest,
	#category : #'MooseIDE-NewTools-Tests-Queries Configuration'
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
