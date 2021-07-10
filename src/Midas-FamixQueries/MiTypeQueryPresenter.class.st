Class {
	#name : #MiTypeQueryPresenter,
	#superclass : #MiQueryConfigurationPresenter,
	#instVars : [
		'typeCheckBoxes'
	],
	#category : #'Midas-FamixQueries-QueriesConfiguration'
}

{ #category : #specs }
MiTypeQueryPresenter class >> title [
	^ 'Type Query'
]

{ #category : #layout }
MiTypeQueryPresenter >> buildLayout [

	self layout:
		(SpBoxLayout newHorizontal add: self typeCheckBoxesLayout)
]

{ #category : #'widgets configuration' }
MiTypeQueryPresenter >> checkBoxesForTypes: types [

	typeCheckBoxes := types collect: [ :type | 
		                  self typeCheckBoxForType: type ].

	"Disable active checkBoxes when the query has only one type, to forbid removing it."
	typeCheckBoxes do: [ :type | 
		type whenChangedDo: [ 
			self query types size == 1
				ifTrue: [ typeCheckBoxes select: #state thenDo: #disable ]
				ifFalse: [ typeCheckBoxes do: #enable ] ] ].

	^ typeCheckBoxes
]

{ #category : #initialization }
MiTypeQueryPresenter >> initializePresenters [

	super initializePresenters.
	self initializeTypeCheckBoxes
]

{ #category : #initialization }
MiTypeQueryPresenter >> initializeTypeCheckBoxes [

	typeCheckBoxes := self query availableTypes
		                  ifEmpty: [ self noParameterMessage: 'type' ]
		                  ifNotEmpty: [ :types | 
		                  self checkBoxesForTypes: types ]
]

{ #category : #'widgets configuration' }
MiTypeQueryPresenter >> labelFor: type [
	^ type mooseDescription name asEnglishPlural
]

{ #category : #'widgets configuration' }
MiTypeQueryPresenter >> typeCheckBoxForType: type [

	| checkBox |
	checkBox := self newCheckBox.
	checkBox
		state: (self query types includes: type);
		enabled: self query types size > 1;
		label: (self labelFor: type);
		whenActivatedDo: [ 
			self query addType: type ];
		whenDeactivatedDo: [ 
			[ self query removeType: type ]
				on: FQCannotRemoveLastType
				do: [ 
					checkBox state: true.
					self flag: #FQSpecPb "Spec does not allow this to work" ] ];
		whenChangedDo: [ 
			self update.
			self notifyQueryChanged ].
	^ checkBox
]

{ #category : #layout }
MiTypeQueryPresenter >> typeCheckBoxesLayout [

	| checkBoxesLayout |
	typeCheckBoxes isCollection ifFalse: [ ^ typeCheckBoxes ].

	checkBoxesLayout := SpBoxLayout newHorizontal.

	(typeCheckBoxes groupsOf: (typeCheckBoxes size // 3 max: 1)) do: [ 
		:group | 
		| subLayout |
		subLayout := SpBoxLayout newVertical.
		group do: [ :checkBox | subLayout add: checkBox ].
		checkBoxesLayout add: subLayout ].

	^ checkBoxesLayout
]

{ #category : #update }
MiTypeQueryPresenter >> updateForQuery: aQuery [
	super updateForQuery: aQuery.
	self updateTypeCheckBoxesForTypes: aQuery types
]

{ #category : #update }
MiTypeQueryPresenter >> updateTypeCheckBoxesForTypes: types [

	| checkBoxesToTick |
	checkBoxesToTick := typeCheckBoxes select: [ :checkBox | 
		                    (types collect: [ :type | self labelFor: type ]) 
			                    includes: checkBox label ].
	checkBoxesToTick do: [ :cb | cb state: true ].
	typeCheckBoxes \ checkBoxesToTick do: [ :cb | cb state: false ]
]
