Class {
	#name : #MiBooleanQueryPresenterTest,
	#superclass : #MiPropertyQueryPresenterTest,
	#category : #'MooseIDE-NewTools-Tests-Queries Configuration'
}

{ #category : #running }
MiBooleanQueryPresenterTest >> classToTest [
	^ MiBooleanQueryPresenter
]

{ #category : #running }
MiBooleanQueryPresenterTest >> queryClass [
	^ FQBooleanQuery
]
