Class {
	#name : #MiBooleanQueryPresenterTest,
	#superclass : #MiPropertyQueryPresenterTest,
	#category : #'Midas-NewTools-Tests-Queries Configuration'
}

{ #category : #running }
MiBooleanQueryPresenterTest >> classToTest [
	^ MiBooleanQueryPresenter
]

{ #category : #running }
MiBooleanQueryPresenterTest >> queryClass [
	^ FQBooleanQuery
]
