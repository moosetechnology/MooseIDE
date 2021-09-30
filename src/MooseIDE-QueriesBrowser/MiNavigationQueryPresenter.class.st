"
A query configuration presenter for the `FQNavigationQuery`
"
Class {
	#name : #MiNavigationQueryPresenter,
	#superclass : #MiQueryConfiguratorPresenter,
	#instVars : [
		'directionDropList',
		'associationsButton',
		'associationsList'
	],
	#category : #'MooseIDE-QueriesBrowser-Configuration presenters'
}

{ #category : #specs }
MiNavigationQueryPresenter class >> title [
	^ 'Navigation Query'
]

{ #category : #actions }
MiNavigationQueryPresenter >> computeQuery: association [

	self updateQueryWithSelectedAssociations:
		associationsList selectedItems
]

{ #category : #initialization }
MiNavigationQueryPresenter >> initializeAssociationsButton [

	associationsButton := self newAssociationsButton
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
	self initializeAssociationsButton.
	self initializeLayout
]

{ #category : #initialization }
MiNavigationQueryPresenter >> newAssociationsButton [

	^  self query availableAssociations
			ifEmpty: [ self noParameterMessage: 'association' ]
			ifNotEmpty: [ 
				self newButton
					label: 'Select Associations...';
					action: [ self showAssociationsPopover ];
				yourself ]
]

{ #category : #layout }
MiNavigationQueryPresenter >> newLayout [

	| padding |
	padding := 5.
	^ SpBoxLayout newLeftToRight
		  add: directionDropList
		  expand: false
		  fill: true
		  padding: padding;
		  add: associationsButton withConstraints: [ :constraints | 
			  constraints
				  width: 150;
				  padding: padding ];
		  yourself
]

{ #category : #initialization }
MiNavigationQueryPresenter >> showAssociationsPopover [
			
	associationsList items: self query availableAssociations.
	self newPopover
		relativeTo: associationsButton;
		presenter: associationsList;
		bePositionRight;
		popup
]

{ #category : #actions }
MiNavigationQueryPresenter >> updateDirection: selectedDirection [

	self query resetAndChangeDirection: selectedDirection.

	associationsButton := self newAssociationsButton.
	self initializeLayout.

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
