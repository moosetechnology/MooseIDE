Class {
	#name : #MiStringQueryPresenter,
	#superclass : #MiPropertyQueryPresenter,
	#category : #'Midas-FamixQueries-QueriesConfiguration'
}

{ #category : #specs }
MiStringQueryPresenter class >> layout [
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
MiStringQueryPresenter >> comparatorsDropList [
	^ self newDropList
		items: self query class comparators;
		display: [ :prop | prop asString ];
		whenSelectedItemChangedDo: [ :prop | 
			self query comparator: prop.
			self notifyQueryChanged ];
		yourself
]

{ #category : #initialization }
MiStringQueryPresenter >> initializeSecondParameter [
	super initializeSecondParameter.
	query availableProperties
		ifNotEmpty: [ secondParameter
				presenterAt: #comparators put: self comparatorsDropList;
				presenterAt: #valueInput put: self valueInputField ]
]

{ #category : #initialization }
MiStringQueryPresenter >> valueInputField [
	^ self newTextInput
		placeholder: 'Your pattern';
		autoAccept: true;
		whenTextChangedDo: [ :pattern | 
			self query valueToCompare: pattern.
			self notifyQueryChanged ];
		yourself
]
