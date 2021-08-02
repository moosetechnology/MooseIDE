"
A query configuration presenter for the `FQTypeQuery` 

"
Class {
	#name : #MiTypeQueryPresenter,
	#superclass : #MiQueryConfigurationPresenter,
	#instVars : [
		'typesButton',
		'typesList'
	],
	#category : #'MooseIDE-NewTools-Queries Browser configuration'
}

{ #category : #specs }
MiTypeQueryPresenter class >> title [
	^ 'Type Query'
]

{ #category : #layout }
MiTypeQueryPresenter >> buildLayout [

	| padding |
	padding := 5.
	self layout: (SpBoxLayout newLeftToRight
			 add: #typesButton
			 expand: false
			 fill: true
			 padding: padding;
			 yourself)
]

{ #category : #actions }
MiTypeQueryPresenter >> computeQuery: aType [

	typesList selectedItems ifEmpty: [ 
		typesList selectItem: aType.
		UIManager default
			alert: 'You must select at least one type'
			title: 'Cannot unselect all types'.
		^ self ].
	self updateQueryWithSelectedTypes: typesList selectedItems
]

{ #category : #initialization }
MiTypeQueryPresenter >> initializePresenters [

	self initializeTypesButton
]

{ #category : #initialization }
MiTypeQueryPresenter >> initializeTypesButton [

	typesButton := self query availableTypes
		               ifEmpty: [ self noParameterMessage: 'type' ]
		               ifNotEmpty: [ 
			               self newButton
				               label: 'Select types';
				               icon: (self iconNamed: #checkboxSelected);
				               action: [ 
					               self newPopover
						               relativeTo: typesButton;
						               bePositionRight;
						               presenter: self typesList;
						               popup ];
				               yourself ]
]

{ #category : #'widgets configuration' }
MiTypeQueryPresenter >> labelFor: type [
	^ type mooseDescription name asEnglishPlural
]

{ #category : #initialization }
MiTypeQueryPresenter >> typesList [

	typesList := self newSelectableListForPopoverExtent: 120 @ 120.

	typesList
		display: [ :item | self labelFor: item ];
		items: self query availableTypes;
		selectItems: self query types;
		onActivation: [ :type | self computeQueryAction: type ];
		onDeactivation: [ :type | self computeQueryAction: type ].
	^ typesList
]

{ #category : #initialization }
MiTypeQueryPresenter >> updateQueryWithSelectedTypes: selectedTypes [

	| nonSelectedTypes |
	nonSelectedTypes := self query types difference: selectedTypes.
	selectedTypes do: [ :type | self query addType: type ].
	nonSelectedTypes do: [ :type | self query removeType: type ].
	self update
]
