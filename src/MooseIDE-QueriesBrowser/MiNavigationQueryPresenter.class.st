"
A query configuration presenter for the `FQNavigationQuery`
"
Class {
	#name : 'MiNavigationQueryPresenter',
	#superclass : 'MiQueryConfiguratorPresenter',
	#instVars : [
		'directionDropList',
		'associationsButton',
		'associationsList',
		'selectedAssociationsLabel'
	],
	#category : 'MooseIDE-QueriesBrowser-Configuration presenters',
	#package : 'MooseIDE-QueriesBrowser',
	#tag : 'Configuration presenters'
}

{ #category : 'specs' }
MiNavigationQueryPresenter class >> title [
	^ 'Navigation Query'
]

{ #category : 'api - actions' }
MiNavigationQueryPresenter >> configureFor: aQuery [

	| queryAssociations |
	queryAssociations := aQuery associations.

	directionDropList selectItem: aQuery directionStrategy.

	associationsButton := self newAssociationsButton.

	associationsList items: associationsList items | queryAssociations.

	queryAssociations do: [ :assoc |
		associationsList activateItem: assoc ].

	query := aQuery
]

{ #category : 'actions' }
MiNavigationQueryPresenter >> configureQuery: association [

	self updateQueryWithSelectedAssociations:
		associationsList selectedItems
]

{ #category : 'initialization' }
MiNavigationQueryPresenter >> initializeAssociationsButton [

	associationsButton := self query availableAssociations
		                      ifEmpty: [ 
		                      self noParameterMessage: 'association' ]
		                      ifNotEmpty: [ self newAssociationsButton ]
]

{ #category : 'initialization' }
MiNavigationQueryPresenter >> initializeAssociationsList [

	associationsList := self instantiate: MiSelectableListPresenter.
	associationsList addStyle: 'largeList'.
	associationsList
		display: [ :item | item mooseDescription name asString ];
		items: self query availableAssociations;
		selectItems: self query associations;
		onActivation: [ self updateLabel ];
		onDeactivation: [ self updateLabel ].

	self query associations do: [ :assoc |
		associationsList activateItem: assoc ]
]

{ #category : 'initialization' }
MiNavigationQueryPresenter >> initializeDirectionsDropList [

	directionDropList := self newDropList.
	directionDropList
		startWithoutSelection;
		items: self query class directionStrategies;
		display: [ :each | each label];
		whenSelectedItemChangedDo: [ :selectedDirection | 
			self updateDirection: selectedDirection ]
]

{ #category : 'initialization' }
MiNavigationQueryPresenter >> initializeLabel [

	selectedAssociationsLabel := self newLabel.
	self updateLabel
]

{ #category : 'initialization' }
MiNavigationQueryPresenter >> initializePresenters [

	self initializeDirectionsDropList.
	self initializeAssociationsList.
	self initializeAssociationsButton.
	self initializeLabel.
	self initializeLayout
]

{ #category : 'initialization' }
MiNavigationQueryPresenter >> newAssociationsButton [

	^ self newButton
		  label: 'Select Associations';
		  action: [ self newAssociationsPopover popup ];
		  yourself
]

{ #category : 'initialization' }
MiNavigationQueryPresenter >> newAssociationsPopover [

	^ self newPopover
		  relativeTo: associationsButton;
		  presenter: associationsList;
		  bePositionRight;
		  whenClosedDo: [
			  self computeQueryAction: associationsList selectedItems ]
]

{ #category : 'layout' }
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

{ #category : 'accessing' }
MiNavigationQueryPresenter >> selectedAssociationsLabel [

	^ selectedAssociationsLabel
]

{ #category : 'actions' }
MiNavigationQueryPresenter >> updateDirection: selectedDirection [

	self query resetAndChangeDirection: selectedDirection.

	self initializeAssociationsList.
	self initializeAssociationsButton.
	self initializeLayout.
	self updateLabel.
	self notifyQueryChanged
]

{ #category : 'actions' }
MiNavigationQueryPresenter >> updateLabel [

	| selectedAssociationsString names reducedNames |
	names := associationsList selectedItems collect: [ :each |
		         each mooseDescription name asString ].
	reducedNames := names size > 2
		                ifTrue: [
				                names collect: [ :each |
						                LbCContractor new
							                usingPriorities;
							                ellipsisUpTo: 8;
							                reduce: each ] ]
		                ifFalse: [ names ].
	selectedAssociationsString := names joinUsing: ', '.
	selectedAssociationsLabel label: selectedAssociationsString
]

{ #category : 'actions' }
MiNavigationQueryPresenter >> updateQueryWithSelectedAssociations: selectedAssociations [

	| nonSelectedAssociations |
	nonSelectedAssociations := self query associations difference:
		                           selectedAssociations.
	selectedAssociations do: [ :assoc | self query addAssociation: assoc ].
	nonSelectedAssociations do: [ :assoc | 
		self query removeAssociation: assoc ]
]
