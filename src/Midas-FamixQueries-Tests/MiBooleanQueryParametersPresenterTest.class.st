Class {
	#name : #MiBooleanQueryParametersPresenterTest,
	#superclass : #MiPropertyQueryParametersPresenterTest,
	#category : #'Midas-FamixQueries-Tests-SubPresenters'
}

{ #category : #running }
MiBooleanQueryParametersPresenterTest >> classToTest [
	^ MiBooleanQueryParametersPresenter
]

{ #category : #running }
MiBooleanQueryParametersPresenterTest >> queryClass [
	^ FQBooleanQuery
]
