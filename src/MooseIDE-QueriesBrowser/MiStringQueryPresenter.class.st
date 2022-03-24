"
A query configuration presenter for the `FQStringQuery`
"
Class {
	#name : #MiStringQueryPresenter,
	#superclass : #MiPropertyQueryPresenter,
	#category : #'MooseIDE-QueriesBrowser-Configuration presenters'
}

{ #category : #actions }
MiStringQueryPresenter >> computeQuery: pattern [

	self query valueToCompare: pattern
]

{ #category : #'api - actions' }
MiStringQueryPresenter >> configureFor: aQuery [

	propertyDropList selectItem: aQuery property.
	comparatorDropList selectItem: aQuery comparator.
	valueInputField text: aQuery valueToCompare.
	query := aQuery
]

{ #category : #initialization }
MiStringQueryPresenter >> initializePresenters [

	super initializePresenters.
	self initializeLayout
]

{ #category : #layout }
MiStringQueryPresenter >> newLayout [

	| padding |
	padding := 5.
	^ SpBoxLayout newLeftToRight
		  add: propertyDropList
		  expand: false
		  fill: true
		  padding: padding;
		  add: comparatorDropList
		  expand: false
		  fill: true
		  padding: padding;
		  add: valueInputField
		  expand: true
		  fill: true
		  padding: padding;
		  yourself
]

{ #category : #initialization }
MiStringQueryPresenter >> newValueInputField [

	^ self newTextInput
		  placeholder: 'Pattern';
		  whenTextChangedDo: [ :pattern | 
			  delayer waitAndRun: [ self computeQueryAction: pattern ] ];
		  yourself
]
