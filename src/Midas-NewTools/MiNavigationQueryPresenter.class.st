Class {
	#name : #MiNavigationQueryPresenter,
	#superclass : #MiQueryConfigurationPresenter,
	#instVars : [
		'directionDropList',
		'associationsTable',
		'associationsButton'
	],
	#category : #'Midas-NewTools-Queries Browser configuration'
}

{ #category : #specs }
MiNavigationQueryPresenter class >> title [
	^ 'Navigation Query'
]

{ #category : #layout }
MiNavigationQueryPresenter >> buildLayout [

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
MiNavigationQueryPresenter >> initializeAssociationsTable [

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
MiNavigationQueryPresenter >> initializeButton [

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
MiNavigationQueryPresenter >> initializeDirectionsDropList [

	directionDropList := self newDropList.
	directionDropList
		items: self query class directionStrategies;
		display: #label;
		whenSelectedItemChangedDo: [ :selectedDirection | 
			self query resetAndChangeDirection: selectedDirection.
			associationsTable items: self query availableAssociations.
			self notifyQueryChanged ]
]

{ #category : #initialization }
MiNavigationQueryPresenter >> initializePresenters [

	self initializeDirectionsDropList.
	self initializeAssociationsTable.
	self initializeButton
]

{ #category : #actions }
MiNavigationQueryPresenter >> updateQueryWithSelectedAssociations: selectedAssociations [

	| nonSelectedAssociations |
	nonSelectedAssociations := self query associations difference:
		                           selectedAssociations.
	selectedAssociations do: [ :assoc | self query addAssociation: assoc ].
	nonSelectedAssociations do: [ :assoc | 
		self query removeAssociation: assoc ].
	self update.
	^ self notifyQueryChanged
]
