Class {
	#name : #MiStringQueryParametersPresenter,
	#superclass : #MiPropertyQueryParametersPresenter,
	#category : #'Midas-FamixQueries-PropertyQuery-SubPresenters'
}

{ #category : #specs }
MiStringQueryParametersPresenter class >> defaultSpec [
	| padding |
	padding := 8.
	^ SpBoxLayout newVertical
		add: #properties
			expand: true
			fill: true
			padding: padding;
		add: #comparators
			expand: true
			fill: true
			padding: padding;
		add: #valueInput
			expand: true
			fill: true
			padding: padding;
		yourself
]

{ #category : #initialization }
MiStringQueryParametersPresenter >> initializePresenters [
	super initializePresenters.
	comparators := self newDropList
		items: self query class comparators;
		display: [ :prop | prop asString ];
		whenSelectedItemChangedDo: [ :prop | 
			self query comparator: prop.
			self owner notifyQueryChanged ];
		yourself.
	valueInput := self newTextInput
		placeholder: 'Your pattern';
		autoAccept: true;
		whenTextChangedDo: [ :pattern | 
			self query valueToCompare: pattern.
			self owner notifyQueryChanged ];
		yourself
]
