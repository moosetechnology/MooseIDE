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
		  add: #propertyDropList
		  expand: true
		  fill: true
		  padding: padding;
		  add: #comparatorDropList
		  expand: true
		  fill: true
		  padding: padding;
		  add: #valueInputField
		  expand: true
		  fill: true
		  padding: padding;
		  yourself
]

{ #category : #initialization }
MiStringQueryPresenter >> initializePresenters [

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
MiStringQueryPresenter >> newComparatorDropList [
	^ self newDropList
		items: self query class comparators;
		display: [ :prop | prop asString ];
		whenSelectedItemChangedDo: [ :prop | 
			self query comparator: prop.
			self notifyQueryChanged ];
		yourself
]

{ #category : #initialization }
MiStringQueryPresenter >> newValueInputField [
	^ self newTextInput
		placeholder: 'Your pattern';
		autoAccept: true;
		whenTextChangedDo: [ :pattern | 
			self query valueToCompare: pattern.
			self notifyQueryChanged ];
		yourself
]
