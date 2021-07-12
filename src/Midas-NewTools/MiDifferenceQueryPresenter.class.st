"
Te configuration presenter for the and (also called subtraction) operation for FamixQueries.
"
Class {
	#name : #MiDifferenceQueryPresenter,
	#superclass : #MiNAryQueryPresenter,
	#category : #'Midas-NewTools-Queries configuration'
}

{ #category : #actions }
MiDifferenceQueryPresenter >> nAryClass [

	^ FQSubtractionQuery
]
