"
A query configuration presenter for the `FQNumericQuery`
"
Class {
	#name : #MiNumericQueryPresenter,
	#superclass : #MiPropertyQueryPresenter,
	#category : #'Midas-NewTools-Queries Browser configuration'
}

{ #category : #specs }
MiNumericQueryPresenter class >> layout [

	| padding |
	padding := 5.
	^ SpBoxLayout newLeftToRight
		  add: #propertyDropList
		  expand: false
		  fill: true
		  padding: padding;
		  add: #comparatorDropList
		  expand: false
		  fill: true
		  padding: padding;
		  add: #valueInputField
		  expand: false
		  fill: true
		  padding: padding;
		  yourself
]

{ #category : #initialization }
MiNumericQueryPresenter >> newValueInputField [

	^ self newNumberInput
		  placeholder: 'Number';
		  climbRate: 1;
		  minimum: 0;
		  autoAccept: true;
		  whenNumberChangedDo: [ :num | 
			  self query valueToCompare: num.
			  self notifyQueryChanged ];
		  yourself
]
