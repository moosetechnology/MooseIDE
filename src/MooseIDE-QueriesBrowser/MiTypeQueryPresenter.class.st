"
A query configuration presenter for the `FQTypeQuery` 

"
Class {
	#name : #MiTypeQueryPresenter,
	#superclass : #MiQueryConfiguratorPresenter,
	#instVars : [
		'typesButton',
		'typesList',
		'selectedTypesLabel'
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
	typesList items: typesList items | aQuery types.
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

	typesList := self newSelectableListForPopoverExtent: 120 @ 120.

	typesList
		display: [ :item | self labelFor: item ];
		items: self query availableTypes;
		selectItems: self query types;
		onActivation: [ :type | self selectTypeAction: type ];
		onDeactivation: [ :type | self selectTypeAction: type ]
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
			  self newPopover
				  relativeTo: typesButton;
				  bePositionRight;
				  presenter: typesList;
				  popup ];
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
