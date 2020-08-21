Class {
	#name : #MiScopeQueriesPresenterTest,
	#superclass : #MiQueryConfigurationPresenterTest,
	#category : #'Midas-FamixQueries-Tests-QueriesConfiguration'
}

{ #category : #running }
MiScopeQueriesPresenterTest >> classToTest [
	^ MiScopeQueryPresenter
]

{ #category : #running }
MiScopeQueriesPresenterTest >> queryClass [
	^ FQScopeQuery
]

{ #category : #tests }
MiScopeQueriesPresenterTest >> testChangingDirectionChangesAvailableScopes [

	| initialScopes |
	initialScopes := presenter query availableScopes copy.

	(presenter directionRadioButtons detect: [ :radioButton | 
		 radioButton state not ]) click.

	self
		denyCollection: initialScopes
		hasSameElements: presenter query availableScopes
]

{ #category : #tests }
MiScopeQueriesPresenterTest >> testDropListMatchesAvailableScopes [

	| scopes |
	scopes := presenter query availableScopes.

	self
		assert: presenter scopesDropList listItems size
		equals: scopes size.

	self
		assertCollection: scopes
		hasSameElements: presenter scopesDropList listItems
]

{ #category : #tests }
MiScopeQueriesPresenterTest >> testDropListMatchesForOtherDirection [

	(presenter directionRadioButtons detect: [ :radioButton | 
		 radioButton state not ]) click.

	self testDropListMatchesAvailableScopes.
	self testDropListMatchesQuery
]

{ #category : #tests }
MiScopeQueriesPresenterTest >> testDropListMatchesQuery [

	self
		assert: presenter scopesDropList selectedItem
		equals: presenter query scope.

	presenter scopesDropList selectItem:
		(presenter query availableScopes detect: [ :scope | 
			 presenter query scope ~~ scope ]).

	self
		assert: presenter scopesDropList selectedItem
		equals: presenter query scope
]

{ #category : #tests }
MiScopeQueriesPresenterTest >> testNoScopesForADirection [

	self resetPresenterWithEntities: helper entitiesWithNoDownScope.

	(presenter directionRadioButtons detect: [ :radioButton | 
		 radioButton label = 'Down' ]) click.

	self
		assert: presenter scopesDropList class
		identicalTo: MiNoPossibleQueryPresenter
]

{ #category : #tests }
MiScopeQueriesPresenterTest >> testPresenters [

	self assert: (presenter directionRadioButtons allSatisfy: [ :pres | 
			 pres class == SpRadioButtonPresenter ]).

	self
		assert: presenter scopesDropList class
		identicalTo: SpDropListPresenter
]

{ #category : #tests }
MiScopeQueriesPresenterTest >> testPresentersOnImpossibleQuery [

	self resetPresenterWithEntities: helper noEntities.

	self assert: (presenter directionRadioButtons allSatisfy: [ :pres | 
			 pres class == SpRadioButtonPresenter ]).

	self
		assert: presenter scopesDropList class
		identicalTo: MiNoPossibleQueryPresenter
]

{ #category : #tests }
MiScopeQueriesPresenterTest >> testQueryValidity [

	self assert: presenter query isValid.

	(presenter directionRadioButtons detect: [ :rb | rb state not ])
		click.
	self assert: presenter query isValid.

	presenter scopesDropList selectItem:
		(presenter scopesDropList listItems copyWithout:
			 presenter scopesDropList selectedItem) anyOne.
	self assert: presenter query isValid.

	self resetPresenterWithEntities: helper entitiesWithNoDownScope.
	(presenter directionRadioButtons detect: [ :radioButton | 
		 radioButton label = 'Down' ]) click.
	self deny: presenter query isValid.

	self resetPresenterWithEntities: helper noEntities.
	self deny: presenter query isValid
]

{ #category : #tests }
MiScopeQueriesPresenterTest >> testRadioButtonsMatchAvailableDirections [

	| directions |
	directions := presenter query directionStrategies.
	self
		assert: presenter directionRadioButtons size
		equals: directions size.

	self
		assertCollection: (directions collect: #label)
		hasSameElements: (presenter directionRadioButtons collect: #label)
]

{ #category : #tests }
MiScopeQueriesPresenterTest >> testRadioButtonsMatchQuery [

	self
		assert: (presenter directionRadioButtons detect: #state) label
		equals: presenter query directionStrategy label.

	(presenter directionRadioButtons detect: [ :rb | rb state not ])
		click.
	self
		assert: (presenter directionRadioButtons detect: #state) label
		equals: presenter query directionStrategy label
]

{ #category : #tests }
MiScopeQueriesPresenterTest >> testUpdateCreationBrowser [

	self assertCreationPresenterWasUpdated.

	(presenter directionRadioButtons detect: [ :rb | rb state not ])
		click.
	self assertCreationPresenterWasUpdated.

	presenter scopesDropList selectItem:
		(presenter query availableScopes detect: [ :scope | 
			 presenter query scope ~~ scope ]).
	self assertCreationPresenterWasUpdated
]
