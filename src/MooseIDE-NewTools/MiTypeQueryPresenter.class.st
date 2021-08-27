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
				               label: 'Select Types...';
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
