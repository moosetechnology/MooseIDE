Class {
	#name : #MiBooleanQueryParametersPresenter,
	#superclass : #MiPropertyQueryParametersPresenter,
	#category : #'Midas-FamixQueries-PropertyQuery-SubPresenters'
}

{ #category : #specs }
MiBooleanQueryParametersPresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #properties
			expand: true
			fill: true
			padding: 50;
		yourself
]
