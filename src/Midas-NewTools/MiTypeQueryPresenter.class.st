Class {
	#name : #MiTypeQueryPresenter,
	#superclass : #MiQueryConfigurationPresenter,
	#instVars : [
		'typesTable',
		'typesButton'
	],
	#category : #'Midas-NewTools-Queries Browser configuration'
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

{ #category : #initialization }
MiTypeQueryPresenter >> initializeButton [

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
MiTypeQueryPresenter >> initializePresenters [

	self initializeTypesTable.
	self initializeButton
]

{ #category : #initialization }
MiTypeQueryPresenter >> initializeTypesTable [

	typesTable := self
		                instantiate: MiMultiSelectionTable
		                on: self query availableTypes.
	typesTable
		displayBlock: [ :item | self labelFor: item ];
		windowName: 'Types';
		whenWindowClosedDo: [ :selectedTypes | 
			self updateQueryWithSelectedTypes: selectedTypes ]
]

{ #category : #'widgets configuration' }
MiTypeQueryPresenter >> labelFor: type [
	^ type mooseDescription name asEnglishPlural
]

{ #category : #initialization }
MiTypeQueryPresenter >> updateQueryWithSelectedTypes: selectedTypes [

	| nonSelectedTypes |
	nonSelectedTypes := self query types difference: selectedTypes.
	selectedTypes do: [ :type | self query addType: type ].
	nonSelectedTypes do: [ :type | self query removeType: type ].
	self update.
	^ self notifyQueryChanged
]
