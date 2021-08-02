"
A query configuration presenter for the `FQScopeQuery`
"
Class {
	#name : #MiScopeQueryPresenter,
	#superclass : #MiQueryConfigurationPresenter,
	#instVars : [
		'scopesDropList',
		'directionsDropList'
	],
	#category : #'MooseIDE-NewTools-Queries Browser configuration'
}

{ #category : #specs }
MiScopeQueryPresenter class >> title [
	^ 'Scope Query'
]

{ #category : #layout }
MiScopeQueryPresenter >> buildLayout [

	| padding |
	padding := 5.
	self layout: (SpBoxLayout newLeftToRight
			 add: #directionsDropList
			 expand: false
			 fill: true
			 padding: padding;
			 add: #scopesDropList
			 expand: false
			 fill: true
			 padding: padding;
			 yourself)
]

{ #category : #actions }
MiScopeQueryPresenter >> computeQuery: scope [

	scope ifNil: [ ^ self ].
	self query scope: scope
]

{ #category : #initialization }
MiScopeQueryPresenter >> initializeDirectionsDropList [

	directionsDropList := self newDropList.
	directionsDropList
		items: self query directionStrategies;
		display: #label;
		whenSelectedItemChangedDo: [ :selectedDirection | 
			self query resetAndChangeDirection: selectedDirection.
			self updateAccordingToDirection.
			self notifyQueryChanged ]
]

{ #category : #initialization }
MiScopeQueryPresenter >> initializePresenters [

	self setScopesDropList.
	self initializeDirectionsDropList
]

{ #category : #'widgets configuration' }
MiScopeQueryPresenter >> scopesDropListForScopes: scopes [

	^ self newDropList
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
	self update
]
