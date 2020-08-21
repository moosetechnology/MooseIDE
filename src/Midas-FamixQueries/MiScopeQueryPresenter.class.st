Class {
	#name : #MiScopeQueryPresenter,
	#superclass : #MiQueryConfigurationPresenter,
	#instVars : [
		'directionRadioButtons',
		'scopesDropList'
	],
	#category : #'Midas-FamixQueries-QueriesConfiguration'
}

{ #category : #specs }
MiScopeQueryPresenter class >> title [
	^ 'Scope Query'
]

{ #category : #layout }
MiScopeQueryPresenter >> buildLayout [

	self layout: (SpBoxLayout newHorizontal
			 add: self directionRadioButtonsLayout;
			 add: self scopesDropListLayout;
			 yourself)
]

{ #category : #layout }
MiScopeQueryPresenter >> directionRadioButtonsLayout [

	| subLayout |
	subLayout := SpBoxLayout newVertical.

	directionRadioButtons do: [ :radioButton | 
		subLayout add: radioButton ].

	^ subLayout
]

{ #category : #initialization }
MiScopeQueryPresenter >> initializePresenters [

	self intializeDirectionRadioButtons.
	self setScopesDropList
]

{ #category : #initialization }
MiScopeQueryPresenter >> intializeDirectionRadioButtons [

	| selectedButton |
	directionRadioButtons := self query directionStrategies collect: [ 
		                         :direction | 
		                         self radioButtonForScopeDirection:
			                         direction ].

	selectedButton := directionRadioButtons detect: #state.
	selectedButton associatedRadioButtons:
		(directionRadioButtons copyWithout: selectedButton)
]

{ #category : #'widgets configuration' }
MiScopeQueryPresenter >> radioButtonForScopeDirection: direction [

	^ self newRadioButton
		  label: direction label;
		  state: direction == self query directionStrategy;
		  whenActivatedDo: [ 
			  self query resetAndChangeDirection: direction.
			  self updateAccordingToDirection.
			  self notifyQueryChanged ]
]

{ #category : #'widgets configuration' }
MiScopeQueryPresenter >> scopesDropListForScopes: scopes [
	^ self newDropList
		items: scopes;
		display: [ :item | item mooseDescription name asEnglishPlural ];
		selectItem: self query scope;
		whenSelectedItemChangedDo: [ :scope | 
			scope ifNil: [ ^ self ].
			self query scope: scope.
			self notifyQueryChanged ]
]

{ #category : #layout }
MiScopeQueryPresenter >> scopesDropListLayout [

	^ SpBoxLayout newVertical
		  add: #scopesDropList
		  expand: true
		  fill: true
		  padding: 50;
		  yourself
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
