"
A query configuration presenter for the `FQNavigationQuery`
"
Class {
	#name : #MiNavigationQueryPresenter,
	#superclass : #MiQueryConfigurationPresenter,
	#instVars : [
		'directionDropList',
		'associationsButton',
		'associationsList'
	],
	#category : #'MooseIDE-NewTools-Queries Browser configuration'
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

{ #category : #actions }
MiNavigationQueryPresenter >> computeQuery: association [

	self updateQueryWithSelectedAssociations:
		associationsList selectedItems
]

{ #category : #initialization }
MiNavigationQueryPresenter >> initializeAssociationsButton [

	associationsButton := self query availableAssociations
		                      ifEmpty: [ self noParameterMessage: 'type' ]
		                      ifNotEmpty: [ 
			                      self newButton
				                      label: 'Select Associations...';
				                      action: [ 
					                      self newPopover
						                      relativeTo: associationsButton;
						                      bePositionRight;
						                      presenter: associationsList;
						                      popup ];
				                      yourself ]
]

{ #category : #initialization }
MiNavigationQueryPresenter >> initializeAssociationsList [

	associationsList := self newSelectableListForPopoverExtent: 120 @ 120.
	associationsList
		display: [ :item | item mooseDescription name asString ];
		items: self query availableAssociations;
		selectItems: self query associations;
		onActivation: [ :association | self computeQueryAction: association ];
		onDeactivation: [ :association | 
			self computeQueryAction: association ]
]

{ #category : #initialization }
MiNavigationQueryPresenter >> initializeDirectionsDropList [

	directionDropList := self newDropList.
	directionDropList
		items: self query class directionStrategies;
		display: #label;
		whenSelectedItemChangedDo: [ :selectedDirection | 
			self updateDirection: selectedDirection ]
]

{ #category : #initialization }
MiNavigationQueryPresenter >> initializePresenters [

	self initializeDirectionsDropList.
	self initializeAssociationsList.
	self initializeAssociationsButton
]

{ #category : #actions }
MiNavigationQueryPresenter >> updateDirection: selectedDirection [

	self query resetAndChangeDirection: selectedDirection.
	self initializeAssociationsButton.
	self update.
	self notifyQueryChanged
]

{ #category : #actions }
MiNavigationQueryPresenter >> updateQueryWithSelectedAssociations: selectedAssociations [

	| nonSelectedAssociations |
	nonSelectedAssociations := self query associations difference:
		                           selectedAssociations.
	selectedAssociations do: [ :assoc | self query addAssociation: assoc ].
	nonSelectedAssociations do: [ :assoc | 
		self query removeAssociation: assoc ]
]
