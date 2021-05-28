Class {
	#name : #MiNavigationInlineQueryPresenter,
	#superclass : #MiNavigationQueryPresenter,
	#instVars : [
		'directionDropList',
		'associationsTable',
		'associationsButton'
	],
	#category : #'Midas-NewTools-Queries configuration'
}

{ #category : #layout }
MiNavigationInlineQueryPresenter >> buildLayout [

	| padding |
	padding := 5.
	self layout: (SpBoxLayout newLeftToRight
			 add: #directionDropList
			 expand: false
			 fill: true
			 padding: padding;
			 add: #associationsButton withConstraints: [ :constraints | 
				 constraints
					 width: 150;
					 padding: padding ] yourself)
]

{ #category : #initialization }
MiNavigationInlineQueryPresenter >> initializeAssociationsCheckBoxes [

	"We override this method because we do not want to build the cheboxes"

	
]

{ #category : #initialization }
MiNavigationInlineQueryPresenter >> initializeAssociationsTable [

	associationsTable := self
		                     instantiate: MiMultiSelectionTable
		                     on: self query availableAssociations.
	associationsTable
		displayBlock: [ :item | item mooseDescription name asString ];
		windowName: 'Associations';
		whenWindowClosedDo: [ :selectedAssociations | 
			self updateQueryWithSelectedAssociations: selectedAssociations ]
]

{ #category : #initialization }
MiNavigationInlineQueryPresenter >> initializeButton [

	associationsButton := self query availableAssociations
		                      ifEmpty: [ self noParameterMessage: 'type' ]
		                      ifNotEmpty: [ 
			                      self newButton
				                      label: 'Select associations';
				                      icon: (self iconNamed: #checkboxSelected);
				                      action: [ associationsTable open ];
				                      yourself ]
]

{ #category : #initialization }
MiNavigationInlineQueryPresenter >> initializeDirectionRadioButtons [

	"We override this method because we do not want to build the radio buttons since we use now a drop list."

	
]

{ #category : #initialization }
MiNavigationInlineQueryPresenter >> initializeDirectionsDropList [

	directionDropList := self newDropList.
	directionDropList
		items: self query class directionStrategies;
		display: #label;
		whenSelectedItemChangedDo: [ :selectedDirection | 
			self query resetAndChangeDirection: selectedDirection.
			self updateAccordingToDirection.
			self notifyQueryChanged ]
]

{ #category : #initialization }
MiNavigationInlineQueryPresenter >> initializePresenters [

	super initializePresenters.
	self initializeDirectionsDropList.
	self initializeAssociationsTable.
	self initializeButton
]

{ #category : #actions }
MiNavigationInlineQueryPresenter >> updateQueryWithSelectedAssociations: selectedAssociations [

	| nonSelectedAssociations |
	nonSelectedAssociations := self query associations difference:
		                           selectedAssociations.
	selectedAssociations do: [ :assoc | self query addAssociation: assoc ].
	nonSelectedAssociations do: [ :assoc | 
		self query removeAssociation: assoc ].
	self update.
	^ self notifyQueryChanged
]
