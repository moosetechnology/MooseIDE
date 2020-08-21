Class {
	#name : #MiBooleanQueryPresenter,
	#superclass : #MiPropertyQueryPresenter,
	#category : #'Midas-FamixQueries-QueriesConfiguration'
}

{ #category : #specs }
MiBooleanQueryPresenter class >> layout [

	^ SpBoxLayout newVertical
		  add: #propertyDropList
		  expand: true
		  fill: true
		  padding: 50;
		  yourself
]
