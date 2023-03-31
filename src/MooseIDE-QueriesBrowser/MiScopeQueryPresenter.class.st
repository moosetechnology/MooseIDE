"
A query configuration presenter for the `FQScopeQuery`
"
Class {
	#name : #MiScopeQueryPresenter,
	#superclass : #MiQueryConfiguratorPresenter,
	#instVars : [
		'scopesDropList',
		'directionsDropList',
		'recursiveCheckbox'
	],
	#category : #'MooseIDE-QueriesBrowser-Configuration presenters'
}

{ #category : #specs }
MiScopeQueryPresenter class >> title [
	^ 'Scope Query'
]

{ #category : #'api - actions' }
MiScopeQueryPresenter >> configureFor: aQuery [

	| queryScope |
	query := aQuery.
	queryScope := aQuery scope.
	directionsDropList selectItem: aQuery directionStrategy.
	scopesDropList := self scopesDropListForScopes: { queryScope }.
	scopesDropList selectItem: queryScope
]

{ #category : #actions }
MiScopeQueryPresenter >> configureQuery: scope [

	scope ifNil: [ ^ self ].
	self query scope: scope
]

{ #category : #initialization }
MiScopeQueryPresenter >> initializeDirectionsDropList [

	directionsDropList := self newDropList.
	directionsDropList
		startWithoutSelection;
		items: self query directionStrategies;
		display: [ :item | item label];
		whenSelectedItemChangedDo: [ :selectedDirection | 
			self query resetAndChangeDirection: selectedDirection.
			self updateAccordingToDirection.
			self notifyQueryChanged ]
]

{ #category : #initialization }
MiScopeQueryPresenter >> initializePresenters [

	scopesDropList := self newDropList.
	self initializeRecursiveCheckbox.
	self initializeDirectionsDropList.
	self initializeLayout
]

{ #category : #initialization }
MiScopeQueryPresenter >> initializeRecursiveCheckbox [

	recursiveCheckbox := self newCheckBox
		                     label: 'Recursive';
		                     help:
			                     'Activate this to recursively look for result in hierarchy.';
		                     whenChangedDo: [ :state | 
			                     self query recursive: state.
			                     self query computeResult.
			                     self notifyQueryChanged ];
		                     yourself
]

{ #category : #layout }
MiScopeQueryPresenter >> newLayout [

	| padding |
	padding := 5.
	^ SpBoxLayout newLeftToRight
		  add: directionsDropList
		  expand: false
		  fill: true
		  padding: padding;
		  add: scopesDropList
		  expand: false
		  fill: true
		  padding: padding;
		  add: recursiveCheckbox width: 30;
		  yourself
]

{ #category : #'widgets configuration' }
MiScopeQueryPresenter >> scopesDropListForScopes: scopes [

	^ self newDropList
		  startWithoutSelection;
		  items: scopes;
		  display: [ :item | item mooseDescription name asEnglishPlural ];
		  selectItem: self query scope;
		  whenSelectedItemChangedDo: [ :scope | 
			  self computeQueryAction: scope ]
]

{ #category : #'widgets configuration' }
MiScopeQueryPresenter >> setScopesDropList [

	scopesDropList := self query availableScopes
		                  ifEmpty: [ self noParameterMessage: 'scope' ]
		                  ifNotEmpty: [ :scopes | 
		                  self scopesDropListForScopes: scopes ]
]

{ #category : #update }
MiScopeQueryPresenter >> updateAccordingToDirection [

	self setScopesDropList.
	self initializeLayout
]
