Class {
	#name : #MiTypeQueryPresenter,
	#superclass : #MiQueryConfigurationPresenter,
	#category : #'Midas-FamixQueries-QueriesConfiguration'
}

{ #category : #specs }
MiTypeQueryPresenter class >> addFirstParameterToLayout: defaultLayout [
	defaultLayout add: #firstParameter width: 0
]

{ #category : #specs }
MiTypeQueryPresenter class >> maximumCheckBoxesPerColumn [
	^ 6
]

{ #category : #specs }
MiTypeQueryPresenter class >> title [
	^ 'Type Query'
]

{ #category : #'widgets configuration' }
MiTypeQueryPresenter >> configureTypeCheckBox: checkBox forType: type [
	checkBox
		state: (self query types includes: type);
		enabled: self query types size > 1;
		label: (self labelFor: type);
		whenActivatedDo: [ self query addType: type ];
		whenDeactivatedDo: [ [ self query removeType: type ]
				on: FQCannotRemoveLastType
				do: [ checkBox state: true.
					self flag: #FQSpecPb	"Spec does not allow this to work" ] ];
		whenChangedDo: [ self update.
			self notifyQueryChanged ]
]

{ #category : #initialization }
MiTypeQueryPresenter >> initializePresenters [
	firstParameter := self newNullPresenter hide.
	self initializeTypeCheckBoxes
]

{ #category : #initialization }
MiTypeQueryPresenter >> initializeTypeCheckBoxes [
	self query availableTypes
		ifEmpty: [ secondParameter := self noParameterMessage: 'type' ]
		ifNotEmpty: [ self showTypesCheckBoxes ]
]

{ #category : #'widgets configuration' }
MiTypeQueryPresenter >> labelFor: type [
	^ type mooseDescription name asEnglishPlural
]

{ #category : #'widgets configuration' }
MiTypeQueryPresenter >> setTypeCheckBoxesConstraints [
	| checkBoxes |
	"Dynamic layout involves NullPresenters, they will not answer to #enable, #disable"
	checkBoxes := secondParameter presenters
		reject: [ :pres | pres class == SpNullPresenter ].

	"Disable active checkBoxes when the query has only one type, to forbid removing it."
	checkBoxes
		do: [ :type | 
			type
				whenChangedDo: [ self query types size == 1
						ifTrue: [ checkBoxes select: #state thenDo: #disable ]
						ifFalse: [ checkBoxes do: #enable ] ] ]
]

{ #category : #'widgets configuration' }
MiTypeQueryPresenter >> showTypesCheckBoxes [
	secondParameter := SpDynamicPresentersListBuilder new
		modelObjects: self query availableTypes;
		presenter: SpCheckBoxPresenter
			configuredAs:
				[ :presenter :type | self configureTypeCheckBox: presenter forType: type ];
		layoutBuilder: self typeCheckBoxesLayout;
		build.
	^ self setTypeCheckBoxesConstraints
]

{ #category : #'widgets configuration' }
MiTypeQueryPresenter >> typeCheckBoxesLayout [
	^ SpDynamicTopToBottomColumnsLayout
		columns: (self query types size min: self class maximumCheckBoxesPerColumn)
]

{ #category : #update }
MiTypeQueryPresenter >> updateForQuery: aQuery [
	super updateForQuery: aQuery.
	self updateTypeCheckBoxesForTypes: aQuery types
]

{ #category : #update }
MiTypeQueryPresenter >> updateTypeCheckBoxesForTypes: types [
	| checkBoxesToTick |
	checkBoxesToTick := firstParameter presenters
		select: [ :checkBox | 
			(types collect: [ :type | self labelFor: type ])
				includes: checkBox label ].
	checkBoxesToTick do: [ :cb | cb state: true ].
	firstParameter presenters \ checkBoxesToTick
		do: [ :cb | cb state: false ]
]
