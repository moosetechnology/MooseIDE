Class {
	#name : #MiStringQueryPresenter,
	#superclass : #MiPropertyQueryPresenter,
	#category : #'Midas-FamixQueries-QueriesConfiguration'
}

{ #category : #specs }
MiStringQueryPresenter class >> layout [

	| padding |
	padding := 5.
	^ SpBoxLayout newVertical
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
