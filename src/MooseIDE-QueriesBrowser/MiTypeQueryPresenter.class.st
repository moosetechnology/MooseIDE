"
A query configuration presenter for the `FQTypeQuery` 

"
Class {
	#name : #MiTypeQueryPresenter,
	#superclass : #MiQueryConfiguratorPresenter,
	#instVars : [
		'typesButton',
		'typesList',
		'selectedTypesLabel',
		'typesModal'
	],
	#category : #'MooseIDE-QueriesBrowser-Configuration presenters'
}

{ #category : #specs }
MiTypeQueryPresenter class >> title [
	^ 'Type Query'
]

{ #category : #'api - actions' }
MiTypeQueryPresenter >> configureFor: aQuery [

	typesButton := self newTypesButton.
	typesList items: self query availableTypes | aQuery types.
	typesList selectItems: aQuery types.
	query types: aQuery types.
	query := aQuery
]

{ #category : #actions }
MiTypeQueryPresenter >> configureQuery: aType [

	self updateQueryWithSelectedTypes: typesList selectedItems
]

{ #category : #initialization }
MiTypeQueryPresenter >> initializeLabel [

	selectedTypesLabel := self newLabel
]

{ #category : #initialization }
MiTypeQueryPresenter >> initializePresenters [

	self initializeTypesList.
	self initializeTypesButton.
	self initializeLabel.
	self initializeLayout
]

{ #category : #initialization }
MiTypeQueryPresenter >> initializeTypesButton [

	typesButton := self query availableTypes
		               ifEmpty: [ self noParameterMessage: 'type' ]
		               ifNotEmpty: [ self newTypesButton ]
]

{ #category : #initialization }
MiTypeQueryPresenter >> initializeTypesList [

	typesList := self instantiate: MiTypeSelectionPresenter on: self
]

{ #category : #'widgets configuration' }
MiTypeQueryPresenter >> labelFor: type [

	^ type mooseDescription name asEnglishPlural
]

{ #category : #layout }
MiTypeQueryPresenter >> newLayout [

	| padding |
	padding := 5.
	^ SpBoxLayout newLeftToRight
		add: typesButton
		expand: false
		fill: true
		padding: padding;
		add: selectedTypesLabel;
		yourself
]

{ #category : #initialization }
MiTypeQueryPresenter >> newTypesButton [

	^ self newButton
		  label: 'Select Types';
		  action: [
			  typesList selectItems: self query types.
			  typesModal := typesList openModal.
			  typesModal isCancelled ifFalse: [ self selectTypeAction: nil ] ];
		  yourself
]

{ #category : #actions }
MiTypeQueryPresenter >> selectTypeAction: aType [

	self updateTypesLabel.
	self computeQueryAction: aType
]

{ #category : #initialization }
MiTypeQueryPresenter >> updateQueryWithSelectedTypes: selectedTypes [

	| nonSelectedTypes |
	nonSelectedTypes := self query types difference: selectedTypes.
	selectedTypes do: [ :type | self query addType: type ].
	nonSelectedTypes do: [ :type | self query removeType: type ]
]

{ #category : #actions }
MiTypeQueryPresenter >> updateTypesLabel [ 

	| selectedTypesText names reducedNames |
	names := typesList selectedItems collect: [ :each | self labelFor: each].
	reducedNames := names size > 4
		ifTrue: [ 
			names collect: [ :each |
			LbCContractor new
				usingPriorities;
				abbreviateNamesUntil: 1;
				removeVowels;
				ellipsisUpTo: 8;
				reduce: each ] ]
		ifFalse: [ names ].
	selectedTypesText := reducedNames joinUsing: ', '.
	selectedTypesLabel label: selectedTypesText
]
