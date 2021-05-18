Class {
	#name : #MiTypeInlineQueryPresenter,
	#superclass : #MiTypeQueryPresenter,
	#instVars : [
		'typesTable',
		'typesButton'
	],
	#category : #'Midas-NewTools-Queries configuration'
}

{ #category : #layout }
MiTypeInlineQueryPresenter >> buildLayout [

	| padding |
	padding := 5.
	self layout: (SpBoxLayout newLeftToRight
			 add: #typesButton
			 expand: false
			 fill: true
			 padding: padding;
			 yourself)
]

{ #category : #initialization }
MiTypeInlineQueryPresenter >> initializeButton [

	typesButton := self query availableTypes
		               ifEmpty: [ self noParameterMessage: 'type' ]
		               ifNotEmpty: [ 
			               self newButton
				               label: 'Select types';
				               icon: (self iconNamed: #checkboxSelected);
				               action: [ typesTable open ];
				               yourself ]
]

{ #category : #initialization }
MiTypeInlineQueryPresenter >> initializePresenters [

	super initializePresenters.
	self initializeTypesTable.
	self initializeButton
]

{ #category : #initialization }
MiTypeInlineQueryPresenter >> initializeTypeCheckBoxes [

	"We do not want to build the types checkboxes"

	
]

{ #category : #initialization }
MiTypeInlineQueryPresenter >> initializeTypesTable [

	typesTable := self
		              instantiate: MiMultiSelectionTable
		              on: self query availableTypes.
	typesTable
		displayBlock: [ :item | self labelFor: item ];
		windowName: 'Types';
		whenWindowClosedDo: [ :selectedTypes | 
			self updateQueryWithSelectedTypes: selectedTypes ]
]

{ #category : #actions }
MiTypeInlineQueryPresenter >> updateQueryWithSelectedTypes: selectedTypes [

	| nonSelectedTypes |
	nonSelectedTypes := self query types difference: selectedTypes.
	selectedTypes do: [ :type | self query addType: type ].
	nonSelectedTypes do: [ :type | self query removeType: type ].
	self update.
	^ self notifyQueryChanged
]
