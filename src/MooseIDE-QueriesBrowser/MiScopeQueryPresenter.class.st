"
A query configuration presenter for the `FQScopeQuery`
"
Class {
	#name : #MiScopeQueryPresenter,
	#superclass : #MiQueryConfiguratorPresenter,
	#instVars : [
		'scopesDropList',
		'directionsDropList'
	],
	#category : #'MooseIDE-QueriesBrowser-Configuration presenters'
}

{ #category : #specs }
MiScopeQueryPresenter class >> title [
	^ 'Scope Query'
]

{ #category : #actions }
MiScopeQueryPresenter >> computeQuery: scope [

	scope ifNil: [ ^ self ].
	self query scope: scope
]

{ #category : #'api - actions' }
MiScopeQueryPresenter >> configureFor: aQuery [

	directionsDropList selectItem: aQuery directionStrategy.
	scopesDropList selectItem: aQuery scope.
	query := aQuery
]

{ #category : #initialization }
MiScopeQueryPresenter >> initializeDirectionsDropList [

	directionsDropList := self newDropList.
	directionsDropList
		startWithoutSelection;
		items: self query directionStrategies;
		display: #label;
		whenSelectedItemChangedDo: [ :selectedDirection | 
			self query resetAndChangeDirection: selectedDirection.
			self updateAccordingToDirection.
			self notifyQueryChanged ]
]

{ #category : #initialization }
MiScopeQueryPresenter >> initializePresenters [

	scopesDropList := self newDropList.
	self initializeDirectionsDropList.
	self initializeLayout
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
