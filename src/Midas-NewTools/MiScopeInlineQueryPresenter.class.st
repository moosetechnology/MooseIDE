Class {
	#name : #MiScopeInlineQueryPresenter,
	#superclass : #MiScopeQueryPresenter,
	#instVars : [
		'directionsDropList'
	],
	#category : #'Midas-NewTools-Queries configuration'
}

{ #category : #layout }
MiScopeInlineQueryPresenter >> buildLayout [

	| padding |
	padding := 5.
	self layout: (SpBoxLayout newLeftToRight
			 add: #directionsDropList
			 expand: false
			 fill: true
			 padding: padding;
			 add: #scopesDropList
			 expand: false
			 fill: true
			 padding: padding;
			 yourself)
]

{ #category : #initialization }
MiScopeInlineQueryPresenter >> initializeDirectionsDropList [

	directionsDropList := self newDropList.
	directionsDropList
		items: self query directionStrategies;
		display: #label;
		whenSelectedItemChangedDo: [ :selectedDirection | 
			self query resetAndChangeDirection: selectedDirection.
			self updateAccordingToDirection.
			self notifyQueryChanged ]
]

{ #category : #initialization }
MiScopeInlineQueryPresenter >> initializePresenters [

	super initializePresenters.
	self initializeDirectionsDropList
]
