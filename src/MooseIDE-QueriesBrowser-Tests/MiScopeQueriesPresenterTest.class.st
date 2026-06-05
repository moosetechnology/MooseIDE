Class {
	#name : 'MiScopeQueriesPresenterTest',
	#superclass : 'MiQueryConfiguratorPresenterTest',
	#category : 'MooseIDE-QueriesBrowser-Tests-Queries Configuration',
	#package : 'MooseIDE-QueriesBrowser-Tests',
	#tag : 'Queries Configuration'
}

{ #category : 'tests' }
MiScopeQueriesPresenterTest >> assertSubpresentersAreConfigured [

	self
		assert: self scopesDropList selectedItem
		equals: self createNewQuery scope.
	self
		assert: self directionsDropList selectedItem
		equals: self createNewQuery directionStrategy
]

{ #category : 'running' }
MiScopeQueriesPresenterTest >> classToTest [
	^ MiScopeQueryPresenter
]

{ #category : 'tests' }
MiScopeQueriesPresenterTest >> createNewQuery [

	| rootQuery |
	rootQuery := FQRootQuery new
		             input: helper classesAndMethods;
		             yourself.
	^ (FQScopeQuery defaultForParent: rootQuery)
		  resetAndChangeDirection: MQScopeContainersStrategy;
		  scope: FamixStClass;
		  yourself
]

{ #category : 'accessing-subpresenters' }
MiScopeQueriesPresenterTest >> directionsDropList [

	^ presenter presenterAt: #directionsDropList
]

{ #category : 'running' }
MiScopeQueriesPresenterTest >> queryClass [
	^ FQScopeQuery
]

{ #category : 'accessing-subpresenters' }
MiScopeQueriesPresenterTest >> scopesDropList [

	^ presenter presenterAt: #scopesDropList
]

{ #category : 'tests' }
MiScopeQueriesPresenterTest >> selectNonSelectedDirection [

	self directionsDropList selectItem:
		self directionsDropList items last
]

{ #category : 'tests' }
MiScopeQueriesPresenterTest >> testChangingDirectionChangesAvailableScopes [

	| initialScopes |
	initialScopes := presenter query availableScopes copy.

	self selectNonSelectedDirection.

	self
		denyCollection: initialScopes
		hasSameElements: presenter query availableScopes
]

{ #category : 'tests' }
MiScopeQueriesPresenterTest >> testDropListMatchesAvailableScopes [

	| scopes |
	scopes := presenter query availableScopes.

	self assert: self scopesDropList listItems size equals: scopes size.

	self
		assertCollection: scopes
		hasSameElements: self scopesDropList listItems
]

{ #category : 'tests' }
MiScopeQueriesPresenterTest >> testDropListMatchesForOtherDirection [

	self selectNonSelectedDirection.

	self testDropListMatchesAvailableScopes.
	self testDropListMatchesQuery
]

{ #category : 'tests' }
MiScopeQueriesPresenterTest >> testDropListMatchesQuery [

	self directionsDropList selectIndex: 1.
	self scopesDropList selectItem:
		(presenter query availableScopes detect: [ :scope |
			 presenter query scope ~~ scope ]).

	self
		assert: self scopesDropList selectedItem
		equals: presenter query scope
]

{ #category : 'tests' }
MiScopeQueriesPresenterTest >> testNoScopesForADirection [

	self resetPresenterWithEntities: helper entitiesWithNoDownScope.

	self directionsDropList selectItem: MQScopeContainedEntitiesStrategy.

	self
		assert: self scopesDropList class
		identicalTo: NoPossibleQueryPresenter
]

{ #category : 'tests' }
MiScopeQueriesPresenterTest >> testPresenters [

	self
		assert: self directionsDropList class
		identicalTo: SpDropListPresenter.
	self
		assert: self scopesDropList class
		identicalTo: SpDropListPresenter
]

{ #category : 'tests' }
MiScopeQueriesPresenterTest >> testPresentersOnImpossibleQuery [

	self resetPresenterWithEntities: helper noEntities.
	presenter query directionStrategy: nil.
	presenter setScopesDropList.
	self
		assert: self directionsDropList class
		identicalTo: SpDropListPresenter.

	self
		assert: self scopesDropList class
		identicalTo: NoPossibleQueryPresenter
]

{ #category : 'tests' }
MiScopeQueriesPresenterTest >> testQueryValidity [

	self directionsDropList selectItem: MQScopeContainedEntitiesStrategy.
	self scopesDropList selectItem: self scopesDropList items anyOne.
	self assert: presenter query isValid.

	self selectNonSelectedDirection.
	self deny: presenter query isValid.

	self scopesDropList selectItem:
		(self scopesDropList listItems copyWithout:
			 self scopesDropList selectedItem) anyOne.
	self assert: presenter query isValid.

	self resetPresenterWithEntities: helper entitiesWithNoDownScope.
	self directionsDropList selectItem: MQScopeContainedEntitiesStrategy.
	self deny: presenter query isValid.

	self resetPresenterWithEntities: helper noEntities.
	self deny: presenter query isValid
]

{ #category : 'tests' }
MiScopeQueriesPresenterTest >> testRadioButtonsMatchAvailableDirections [

	| directions |
	directions := presenter query directionStrategies.
	self
		assert: self directionsDropList items size
		equals: directions size.

	self
		assertCollection: (directions collect: #label)
		hasSameElements: (self directionsDropList items collect: #label)
]

{ #category : 'tests' }
MiScopeQueriesPresenterTest >> testRadioButtonsMatchQuery [

	self selectNonSelectedDirection.
	self
		assert: self directionsDropList selectedItem label
		equals: presenter query directionStrategy label
]
