"
Te configuration presenter for the and (also called union) operation for FamixQueries.
"
Class {
	#name : #MiOrQueryPresenter,
	#superclass : #MiNAryQueryPresenter,
	#category : #'Midas-NewTools-Queries configuration'
}

{ #category : #actions }
MiOrQueryPresenter >> nAryClass [

	^ FQUnionQuery
]
