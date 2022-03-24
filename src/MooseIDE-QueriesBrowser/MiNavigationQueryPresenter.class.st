"
A query configuration presenter for the `FQNavigationQuery`
"
Class {
	#name : #MiNavigationQueryPresenter,
	#superclass : #MiQueryConfiguratorPresenter,
	#instVars : [
		'directionDropList',
		'associationsButton',
		'associationsList',
		'selectedAssociationsLabel'
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

{ #category : #'api - actions' }
MiNavigationQueryPresenter >> configureFor: aQuery [

	directionDropList selectItem: aQuery directionStrategy.
	associationsList selectItems: aQuery associations.
	query := aQuery
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
		onActivation: [ :association | 
			self selectAssociationAction: association ];
		onDeactivation: [ :association | 
			self selectAssociationAction: association ]
]

{ #category : #initialization }
MiNavigationQueryPresenter >> initializeDirectionsDropList [

	directionDropList := self newDropList.
	directionDropList
		startWithoutSelection;
		items: self query class directionStrategies;
		display: #label;
		whenSelectedItemChangedDo: [ :selectedDirection | 
			self updateDirection: selectedDirection ]
]

{ #category : #initialization }
MiNavigationQueryPresenter >> initializeLabel [

	selectedAssociationsLabel := self newLabel.
	self updateLabel
]

{ #category : #initialization }
MiNavigationQueryPresenter >> initializePresenters [

	self initializeDirectionsDropList.
	self initializeAssociationsList.
	self initializeAssociationsButton.
	self initializeLabel.
	self initializeLayout
]

{ #category : #initialization }
MiNavigationQueryPresenter >> newAssociationsButton [

	^  self query availableAssociations
			ifEmpty: [ self noParameterMessage: 'association' ]
			ifNotEmpty: [ 
				self newButton
					label: 'Select Associations';
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
				width: 125;
				padding: padding ];
		add: selectedAssociationsLabel;
		yourself
]

{ #category : #actions }
MiNavigationQueryPresenter >> selectAssociationAction: association [

	self updateLabel.
	self computeQueryAction: association
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
MiNavigationQueryPresenter >> updateLabel [
	
	| selectedAssociationsString names reducedNames |
	names := associationsList selectedItems collect: [ :each |
		each mooseDescription name asString ].
	reducedNames := names size > 2
	ifTrue: [
		names collect: [ :each |
			LbCContractor new
				usingPriorities;
				removeVowels;
				ellipsisUpTo: 8;
				reduce: each ] ]
	ifFalse: [ names ].
	selectedAssociationsString := reducedNames joinUsing: ', '.
	selectedAssociationsLabel label: selectedAssociationsString
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
