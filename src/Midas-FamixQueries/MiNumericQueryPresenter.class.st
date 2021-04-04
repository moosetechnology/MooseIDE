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
MiNumericQueryPresenter >> newValueInputField [
	^ super newValueInputField
		placeholder: 'Your numeric value' ;
		climbRate: 1 ;
		minimum: 0 ;
		yourself
]
