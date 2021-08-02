"
A query configuration presenter for the `FQStringQuery`
"
Class {
	#name : #MiStringQueryPresenter,
	#superclass : #MiPropertyQueryPresenter,
	#category : #'MooseIDE-NewTools-Queries Browser configuration'
}

{ #category : #specs }
MiStringQueryPresenter class >> layout [

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
		  expand: true
		  fill: true
		  padding: padding;
		  yourself
]

{ #category : #actions }
MiStringQueryPresenter >> computeQuery: pattern [

	self query valueToCompare: pattern
]

{ #category : #initialization }
MiStringQueryPresenter >> newValueInputField [

	^ self newTextInput
		  placeholder: 'Pattern';
		  autoAccept: true;
		  whenTextChangedDo: [ :pattern | self computeQueryAction: pattern ];
		  yourself
]
