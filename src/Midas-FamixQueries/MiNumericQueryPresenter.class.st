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
		  add: #propertyDropList
		  expand: true
		  fill: true
		  padding: padding;
		  add: #comparatorDropList
		  expand: false
		  fill: false
		  padding: padding;
		  add: #valueInputField
		  expand: true
		  fill: true
		  padding: padding;
		  yourself
]

{ #category : #initialization }
MiNumericQueryPresenter >> initializePresenters [

	super initializePresenters.
	query availableProperties
		ifNotEmpty: [ 
			comparatorDropList := self newComparatorDropList.
			valueInputField := self newValueInputField ]
		ifEmpty: [ 
			comparatorDropList := self newNullPresenter.
			valueInputField := self newNullPresenter ]
]

{ #category : #initialization }
MiNumericQueryPresenter >> newComparatorDropList [
	^ self newDropList
		items: self query class comparators;
		display: [ :prop | prop asString ];
		whenSelectedItemChangedDo: [ :prop | 
			self query comparator: prop.
			self notifyQueryChanged ];
		yourself
]

{ #category : #initialization }
MiNumericQueryPresenter >> newValueInputField [
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
