Class {
	#name : #MiNumericQueryPresenter,
	#superclass : #MiPropertyQueryPresenter,
	#category : #'Midas-FamixQueries-QueriesConfiguration'
}

{ #category : #specs }
MiNumericQueryPresenter class >> layout [
	| padding |
	padding := 8.
	^ SpBoxLayout newVertical
		add: #properties
			expand: true
			fill: true
			padding: padding;
		add: #comparators
			expand: false
			fill: false
			padding: padding;
		add: #valueInput
			expand: true
			fill: true
			padding: padding;
		yourself
]

{ #category : #initialization }
MiNumericQueryPresenter >> comparatorsDropList [
	^ self newDropList
		items: self query class comparators;
		display: [ :prop | prop asString ];
		whenSelectedItemChangedDo: [ :prop | 
			self query comparator: prop.
			self notifyQueryChanged ];
		yourself
]

{ #category : #initialization }
MiNumericQueryPresenter >> initializeSecondParameter [
	super initializeSecondParameter.
	query availableProperties
		ifNotEmpty: [ secondParameter
				presenterAt: #comparators put: self comparatorsDropList;
				presenterAt: #valueInput put: self valueInputField ]
]

{ #category : #initialization }
MiNumericQueryPresenter >> valueInputField [
	^ self newNumberInput
		placeholder: 'Your numeric value';
		climbRate: 1;
		minimum: 0;
		autoAccept: true;
		whenNumberChangedDo: [ :num | 
			self query valueToCompare: num.
			self notifyQueryChanged ];
		yourself
]
