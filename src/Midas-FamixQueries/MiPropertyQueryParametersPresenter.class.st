Class {
	#name : #MiPropertyQueryParametersPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'properties',
		'comparators',
		'valueInput'
	],
	#category : #'Midas-FamixQueries-PropertyQuery-SubPresenters'
}

{ #category : #initialization }
MiPropertyQueryParametersPresenter >> initializePresenters [
	properties := self newDropList
		items: self query availableProperties;
		display: [ :prop | prop asString ];
		whenSelectedItemChangedDo: [ :prop | 
			self query property: prop.
			self owner notifyQueryChanged ];
		yourself
]

{ #category : #accessing }
MiPropertyQueryParametersPresenter >> query [
	^ owner query
]
