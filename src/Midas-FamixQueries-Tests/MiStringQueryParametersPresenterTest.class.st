Class {
	#name : #MiStringQueryParametersPresenterTest,
	#superclass : #MiComparativeQueryParametersPresenterTest,
	#category : #'Midas-FamixQueries-Tests-SubPresenters'
}

{ #category : #running }
MiStringQueryParametersPresenterTest >> classToTest [
	^ MiStringQueryParametersPresenter
]

{ #category : #running }
MiStringQueryParametersPresenterTest >> queryClass [
	^ FQStringQuery
]

{ #category : #running }
MiStringQueryParametersPresenterTest >> valueInput [
	^ 'LAN'
]

{ #category : #running }
MiStringQueryParametersPresenterTest >> valueInputClass [
	^ SpTextInputFieldPresenter
]
