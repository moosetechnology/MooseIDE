Class {
	#name : #MiBooleanQueryPresenterTest,
	#superclass : #MiPropertyQueryPresenterTest,
	#category : #'MooseIDE-QueriesBrowser-Tests-Queries Configuration'
}

{ #category : #running }
MiBooleanQueryPresenterTest >> classToTest [
	^ MiBooleanQueryPresenter
]

{ #category : #running }
MiBooleanQueryPresenterTest >> queryClass [
	^ FQBooleanQuery
]
