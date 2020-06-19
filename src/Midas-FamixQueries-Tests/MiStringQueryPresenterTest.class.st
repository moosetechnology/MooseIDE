Class {
	#name : #MiStringQueryPresenterTest,
	#superclass : #MiComparativeQueryPresenterTest,
	#category : #'Midas-FamixQueries-Tests-QueriesConfiguration'
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
