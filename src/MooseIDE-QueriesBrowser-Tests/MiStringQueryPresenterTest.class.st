Class {
	#name : #MiStringQueryPresenterTest,
	#superclass : #MiComparativeQueryPresenterTest,
	#category : #'MooseIDE-QueriesBrowser-Tests-Queries Configuration'
}

{ #category : #running }
MiStringQueryPresenterTest >> classToTest [
	^ MiStringQueryPresenter
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
