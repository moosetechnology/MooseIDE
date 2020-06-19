Class {
	#name : #MiNavigationQueryPresenter,
	#superclass : #MiQueryConfigurationPresenter,
	#category : #'Midas-FamixQueries-QueriesConfiguration'
}

{ #category : #specs }
MiNavigationQueryPresenter class >> title [
	^ 'Navigation Query'
]

{ #category : #'widgets configuration' }
MiNavigationQueryPresenter >> configureCheckBox: checkBox forNavigationAssociation: associationClass [
	self setStateOfCheckBox: checkBox association: associationClass.
	checkBox
		label: associationClass mooseDescription name asString;
		whenActivatedDo: [ self query addAssociation: associationClass ];
		whenDeactivatedDo: [ [ self query removeAssociation: associationClass ]
				on: FQCannotRemoveLastNavigationAssociation
				do: [ checkBox state: true
					"Spec does not allow this to work" ] ].
	checkBox
		whenChangedDo: [ self update.
			self notifyQueryChanged ]
]

{ #category : #'widgets configuration' }
MiNavigationQueryPresenter >> configureRadioButton: radioButton forNavigationDirection: direction [
	radioButton
		state: self query directionStrategy == direction;
		label: direction label;
		whenActivatedDo: [ self query resetAndChangeDirection: direction.
			self updateAccordingToDirection.
			self notifyQueryChanged ]
]

{ #category : #initialization }
MiNavigationQueryPresenter >> initializeAssociationsCheckBoxes [
	self updateAccordingToDirection
]

{ #category : #initialization }
MiNavigationQueryPresenter >> initializeDirectionRadioButtons [
	firstParameter := SpDynamicPresentersListBuilder new
		modelObjects: self query class directionStrategies;
		presenter: SpRadioButtonPresenter
			configuredAs: [ :radioButton :direction | 
			self
				configureRadioButton: radioButton
				forNavigationDirection: direction ];
		layoutBuilder: (SpDynamicTopToBottomRowsLayout rows: 1);
		build.
	(firstParameter presenters detect: #state)
		associatedRadioButtons: firstParameter presenters allButFirst
]

{ #category : #initialization }
MiNavigationQueryPresenter >> initializePresenters [
	self initializeDirectionRadioButtons.
	self initializeAssociationsCheckBoxes
]

{ #category : #'widgets configuration' }
MiNavigationQueryPresenter >> selectCurrentQueryDirection [
	(firstParameter presenters
		detect:
			[ :radioButton | radioButton label = self query directionStrategy label ])
		state: true
]

{ #category : #initialization }
MiNavigationQueryPresenter >> setAssociationsCheckBoxesConstraints [
	| checkBoxes |
	"Dynamic layout involves NullPresenters, they will not answer to #enable, #disable"
	checkBoxes := secondParameter presenters
		reject: [ :pres | pres class == SpNullPresenter ].

	"Disable active checkBoxes when the query has only one association, to forbid removing it."
	checkBoxes
		do: [ :association | 
			association
				whenChangedDo: [ self query associations size == 1
						ifTrue: [ checkBoxes select: #state thenDo: #disable ]
						ifFalse: [ checkBoxes select: #state thenDo: #enable ] ] ]
]

{ #category : #'widgets configuration' }
MiNavigationQueryPresenter >> setStateOfCheckBox: checkBox association: associationClass [
	checkBox state: (self query associations includes: associationClass).
	checkBox enabled: self query associations size > 1
]

{ #category : #update }
MiNavigationQueryPresenter >> showAssociationsCheckBoxes [
	secondParameter := SpDynamicPresentersListBuilder new
		modelObjects: self query availableAssociations;
		presenter: SpCheckBoxPresenter
			configuredAs: [ :checkBox :associationTrait | 
			self
				configureCheckBox: checkBox
				forNavigationAssociation: associationTrait ];
		layoutBuilder: (SpDynamicLeftToRightRowsLayout rows: 1);
		build.
	self setAssociationsCheckBoxesConstraints
]

{ #category : #update }
MiNavigationQueryPresenter >> updateAccordingToDirection [
	self query availableAssociations
		ifEmpty: [ secondParameter := self noParameterMessage: 'association' ]
		ifNotEmpty: [ self showAssociationsCheckBoxes ].
	self update
]
