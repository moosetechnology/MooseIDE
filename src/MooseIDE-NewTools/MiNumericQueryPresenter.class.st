"
A query configuration presenter for the `FQNumericQuery`
"
Class {
	#name : #MiNumericQueryPresenter,
	#superclass : #MiPropertyQueryPresenter,
	#category : #'MooseIDE-NewTools-Queries Browser configuration'
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
		  add: #comparatorDropList withConstraints: [ :constraints | 
			  constraints
				  padding: padding;
				  width: 63 ];
		  add: #valueInputField withConstraints: [ :constraints | 
		  constraints
			  padding: padding;
			  width: 70 ];
		  yourself
]

{ #category : #actions }
MiNumericQueryPresenter >> computeQuery: num [

	self query valueToCompare: num
]

{ #category : #initialization }
MiNumericQueryPresenter >> newValueInputField [

	^ self newNumberInput
		  placeholder: 'Value';
		  climbRate: 1;
		  minimum: 0;
		  autoAccept: true;
		  whenNumberChangedDo: [ :num | self computeQueryAction: num ];
		  yourself
]
