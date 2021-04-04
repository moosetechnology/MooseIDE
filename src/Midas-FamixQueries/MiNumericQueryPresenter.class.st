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
