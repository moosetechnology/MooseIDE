"
A query configuration presenter for the `FQNumericQuery`
"
Class {
	#name : #MiNumericQueryPresenter,
	#superclass : #MiPropertyQueryPresenter,
	#category : #'MooseIDE-QueriesBrowser-Configuration presenters'
}

{ #category : #actions }
MiNumericQueryPresenter >> computeQuery: num [

	self query valueToCompare: num
]

{ #category : #'api - actions' }
MiNumericQueryPresenter >> configureFor: aQuery [

	propertyDropList selectItem: aQuery property.
	comparatorDropList selectItem: aQuery comparator.
	valueInputField number: aQuery valueToCompare.
	query := aQuery
]

{ #category : #initialization }
MiNumericQueryPresenter >> initializePresenters [

	super initializePresenters.
	self initializeLayout
]

{ #category : #layout }
MiNumericQueryPresenter >> newLayout [

	| padding |
	padding := 5.
	^ SpBoxLayout newLeftToRight
		add: propertyDropList
		expand: false
		fill: true
		padding: padding;
		add: comparatorDropList withConstraints: [ :constraints | 
			constraints
				padding: padding;
				width: 63 ];
		add: valueInputField withConstraints: [ :constraints | 
			constraints
				padding: padding;
				width: 70 ];
		yourself
]

{ #category : #initialization }
MiNumericQueryPresenter >> newValueInputField [

	^ self newNumberInput
		  placeholder: 'Value';
		  climbRate: 1;
		  minimum: 0;
		  whenNumberChangedDo: [ :num | 
			  delayer waitAndRun: [ self computeQueryAction: num ] ];
		  yourself
]
