"
Te configuration presenter for the and (also called intersection) operation for FamixQueries.
"
Class {
	#name : #MiAndQueryPresenter,
	#superclass : #MiNAryQueryPresenter,
	#category : #'Midas-NewTools-Queries configuration'
}

{ #category : #actions }
MiAndQueryPresenter >> nAryClass [

	^ FQIntersectionQuery
]
