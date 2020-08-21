Class {
	#name : #MiNavigationQueryPresenter,
	#superclass : #MiQueryConfigurationPresenter,
	#instVars : [
		'directionRadioButtons',
		'associationCheckBoxes'
	],
	#category : #'Midas-FamixQueries-QueriesConfiguration'
}

{ #category : #specs }
MiNavigationQueryPresenter class >> title [
	^ 'Navigation Query'
]

{ #category : #layout }
MiNavigationQueryPresenter >> associationCheckBoxesLayout [

	| subLayout |
	associationCheckBoxes isCollection ifFalse: [ 
		^ associationCheckBoxes ].

	subLayout := SpBoxLayout newVertical.

	associationCheckBoxes do: [ :checkBox | 
		subLayout add: checkBox height: self class buttonHeight ].

	^ subLayout
]

{ #category : #layout }
MiNavigationQueryPresenter >> buildLayout [

	self layout: (SpBoxLayout newHorizontal
			 add: self directionRadioButtonsLayout;
			 add: self associationCheckBoxesLayout;
			 yourself)
]

{ #category : #'widgets configuration' }
MiNavigationQueryPresenter >> checkBoxForNavigationAssociation: associationClass [

	| checkBox |
	checkBox := self newCheckBox.
	checkBox
		state: (self query associations includes: associationClass);
		enabled: self query associations size > 1;
		label: associationClass mooseDescription name asString;
		whenActivatedDo: [ self query addAssociation: associationClass ];
		whenDeactivatedDo: [ 
			[ self query removeAssociation: associationClass ]
				on: FQCannotRemoveLastNavigationAssociation
				do: [ 
					checkBox state: true
					"Spec does not allow this to work" ] ];
		whenChangedDo: [ 
			self update.
			self notifyQueryChanged.
			self query associations size == 1
				ifTrue: [ associationCheckBoxes select: #state thenDo: #disable ]
				ifFalse: [ associationCheckBoxes select: #state thenDo: #enable ] ].
	^ checkBox
]

{ #category : #layout }
MiNavigationQueryPresenter >> directionRadioButtonsLayout [

	| subLayout |
	subLayout := SpBoxLayout newVertical.

	directionRadioButtons do: [ :radioButton | 
		subLayout add: radioButton height: self class buttonHeight ].

	^ subLayout
]

{ #category : #initialization }
MiNavigationQueryPresenter >> initializeAssociationsCheckBoxes [

	self setAssociationCheckBoxes
]

{ #category : #initialization }
MiNavigationQueryPresenter >> initializeDirectionRadioButtons [

	| selectedButton |
	directionRadioButtons := self query class directionStrategies 
		                         collect: [ :direction | 
		                         self radioButtonForNavigationDirection:
			                         direction ].
	selectedButton := directionRadioButtons detect: #state.
	selectedButton associatedRadioButtons:
		(directionRadioButtons copyWithout: selectedButton)
]

{ #category : #initialization }
MiNavigationQueryPresenter >> initializePresenters [
	self initializeDirectionRadioButtons.
	self initializeAssociationsCheckBoxes
]

{ #category : #'widgets configuration' }
MiNavigationQueryPresenter >> radioButtonForNavigationDirection: direction [

	^ self newRadioButton
		  state: self query directionStrategy == direction;
		  label: direction label;
		  whenActivatedDo: [ 
			  self query resetAndChangeDirection: direction.
			  self updateAccordingToDirection.
			  self notifyQueryChanged ]
]

{ #category : #'widgets configuration' }
MiNavigationQueryPresenter >> setAssociationCheckBoxes [

	associationCheckBoxes := self query availableAssociations
		                         ifEmpty: [ 
		                         self noParameterMessage: 'association' ]
		                         ifNotEmpty: [ :associations | 
			                         associations collect: [ :associationTrait | 
				                         self checkBoxForNavigationAssociation:
					                         associationTrait ] ]
]

{ #category : #update }
MiNavigationQueryPresenter >> updateAccordingToDirection [

	self setAssociationCheckBoxes.
	self buildLayout.
	self update
]
