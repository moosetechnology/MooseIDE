Class {
	#name : #MiScopeQueriesPresenterTest,
	#superclass : #MiQueryConfigurationPresenterTest,
	#category : #'Midas-FamixQueries-Tests-Presenters'
}

{ #category : #running }
MiScopeQueriesPresenterTest >> classToTest [
	^ MiScopeQueriesPresenter
]

{ #category : #running }
MiScopeQueriesPresenterTest >> dropList [
	^ presenter secondParameter
]

{ #category : #running }
MiScopeQueriesPresenterTest >> queryClass [
	^ FQScopeQuery
]

{ #category : #accessing }
MiScopeQueriesPresenterTest >> radioButtons [
	^ presenter firstParameter presenters
		reject: [ :pres | pres class = SpNullPresenter ]
]

{ #category : #tests }
MiScopeQueriesPresenterTest >> testChangingDirectionChangesAvailableScopes [
	| initialScopes |
	initialScopes := presenter query availableScopes copy.
	
	(self radioButtons
		detect: [ :radioButton | radioButton state not ]) click.
	
	self
		denyCollection: initialScopes
		hasSameElements: presenter query availableScopes
]

{ #category : #tests }
MiScopeQueriesPresenterTest >> testDropListMatchesAvailableScopes [
	| scopes |
	scopes := presenter query availableScopes.
	
	self assert: self dropList listItems size equals: scopes size.
	
	self assertCollection: scopes hasSameElements: self dropList listItems .
]

{ #category : #tests }
MiScopeQueriesPresenterTest >> testDropListMatchesForOtherDirection [

	(self radioButtons
		detect: [ :radioButton | radioButton state not ]) click.

	self testDropListMatchesAvailableScopes.
	self testDropListMatchesQuery
]

{ #category : #tests }
MiScopeQueriesPresenterTest >> testDropListMatchesQuery [
	self
		assert: self dropList selectedItem
		equals: self currentQuery scope.
	
	self dropList selectItem:
		(presenter query availableScopes
			detect: [ :scope | self currentQuery scope ~~ scope ]).

	self
		assert: self dropList selectedItem
		equals: self currentQuery scope
]

{ #category : #tests }
MiScopeQueriesPresenterTest >> testFirstParameter [
	self assert:
		(presenter firstParameter presenters
			allSatisfy: [ :pres | pres class == SpRadioButtonPresenter ]).

	self resetPresenterWithEntities: helper noEntities.
	self assert:
		(presenter firstParameter presenters
			allSatisfy: [ :pres | pres class == SpRadioButtonPresenter ])
]

{ #category : #tests }
MiScopeQueriesPresenterTest >> testNoScopesForADirection [
	self resetPresenterWithEntities: helper entitiesWithNoDownScope.
	
	(presenter firstParameter presenters
		detect: [ :radioButton | radioButton label = 'Down' ]) click.
	
	self
		assert: presenter secondParameter class
		identicalTo: MiNoPossibleQueryPresenter
]

{ #category : #tests }
MiScopeQueriesPresenterTest >> testQueryValidity [
	self assert: presenter query isValid.
	
	(self radioButtons detect: [ :rb | rb state not ]) click.
	self assert: presenter query isValid.
	
	self dropList selectItem: (self dropList listItems copyWithout: self dropList selectedItem) anyOne.
	self assert: presenter query isValid.
	
	self resetPresenterWithEntities: helper entitiesWithNoDownScope.
	(presenter firstParameter presenters
		detect: [ :radioButton | radioButton label = 'Down' ]) click.
	self deny: presenter query isValid.
	
	self resetPresenterWithEntities: helper noEntities.
	self deny: presenter query isValid
]

{ #category : #tests }
MiScopeQueriesPresenterTest >> testRadioButtonsMatchAvailableDirections [
	| directions |
	directions := presenter query directionStrategies.
	self assert: self radioButtons size equals: directions size.
	
	self
		assertCollection: (directions collect: #label)
		hasSameElements: (self radioButtons collect: #label)
]

{ #category : #tests }
MiScopeQueriesPresenterTest >> testRadioButtonsMatchQuery [
	self
		assert: (self radioButtons detect: #state) label
		equals: self currentQuery directionStrategy label.
	
	(self radioButtons detect: [ :rb | rb state not ]) click.
	self
		assert: (self radioButtons detect: #state) label
		equals: self currentQuery directionStrategy label
]

{ #category : #tests }
MiScopeQueriesPresenterTest >> testSecondParameter [
	self
		assert: presenter secondParameter class
		identicalTo: SpDropListPresenter.
	
	self resetPresenterWithEntities: helper noEntities.
	self
		assert: presenter secondParameter class
		identicalTo: MiNoPossibleQueryPresenter
]

{ #category : #tests }
MiScopeQueriesPresenterTest >> testUpdateCreationBrowser [
	self assertCreationPresenterWasUpdated.
	
	(self radioButtons detect: [ :rb | rb state not ]) click.
	self assertCreationPresenterWasUpdated.
	
	self dropList
		selectItem:
			(presenter query availableScopes
				detect: [ :scope | self currentQuery scope ~~ scope ]).
	self assertCreationPresenterWasUpdated
]
