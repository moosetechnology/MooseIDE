Class {
	#name : #MiNavigationQueriesPresenterTest,
	#superclass : #MiQueryConfigurationPresenterTest,
	#category : #'Midas-FamixQueries-Tests-QueriesConfiguration'
}

{ #category : #running }
MiNavigationQueriesPresenterTest >> assertCheckBoxesMatchAvailableAssociations [

	| availableAssociations |
	availableAssociations := presenter query availableAssociations.
	self
		assert: presenter associationCheckBoxes size
		equals: availableAssociations size.
	self
		assert: (presenter associationCheckBoxes select: #state) size
		equals: availableAssociations size.
	self
		assertCollection: (availableAssociations collect: [ :assoc | 
				 assoc mooseDescription name asString ])
		hasSameElements:
		(presenter associationCheckBoxes select: #state thenCollect: #label)
]

{ #category : #running }
MiNavigationQueriesPresenterTest >> assertCheckBoxesMatchQuery [

	self
		assertCollection: (presenter query associations collect: [ :type | 
				 type mooseDescription name asString ])
		hasSameElements:
		(presenter associationCheckBoxes select: #state thenCollect: #label).

	(presenter directionRadioButtons detect: [ :rb | rb state not ])
		click.

	self
		assertCollection: (presenter query associations collect: [ :type | 
				 type mooseDescription name asString ])
		hasSameElements:
		(presenter associationCheckBoxes select: #state thenCollect: #label)
]

{ #category : #running }
MiNavigationQueriesPresenterTest >> classToTest [
	^ MiNavigationQueryPresenter
]

{ #category : #running }
MiNavigationQueriesPresenterTest >> queryClass [
	^ FQNavigationQuery
]

{ #category : #tests }
MiNavigationQueriesPresenterTest >> testCheckBoxesDisabledWhenOnlyOneChecked [

	self resetPresenterWithEntities: helper methods.
	(presenter directionRadioButtons detect: [ :radioButton | 
		 radioButton label = 'Local Incoming' ]) click.

	"Only 1 association in the query, cannot be removed, so all checkBoxes are disabled"
	presenter associationCheckBoxes do: [ :cb | self deny: cb isEnabled ].
	self
		assert: (presenter associationCheckBoxes select: #state) size
		equals: 1
]

{ #category : #tests }
MiNavigationQueriesPresenterTest >> testCheckBoxesMatchAssociations [

	self assertCheckBoxesMatchAvailableAssociations.
	self assertCheckBoxesMatchQuery.
	(presenter directionRadioButtons detect: [ :rb | rb state not ])
		click.
	self assertCheckBoxesMatchAvailableAssociations.
	self assertCheckBoxesMatchQuery
]

{ #category : #tests }
MiNavigationQueriesPresenterTest >> testPresenters [

	self assert: (presenter directionRadioButtons allSatisfy: [ :pres | 
			 pres class == SpRadioButtonPresenter ]).

	self assert: (presenter associationCheckBoxes allSatisfy: [ :pres | 
			 pres class == SpCheckBoxPresenter ])
]

{ #category : #tests }
MiNavigationQueriesPresenterTest >> testPresentersOnImpossibleQuery [

	self resetPresenterWithEntities: helper noEntities.

	self assert: (presenter directionRadioButtons allSatisfy: [ :pres | 
			 pres class == SpRadioButtonPresenter ]).

	self
		assert: presenter associationCheckBoxes class
		identicalTo: MiNoPossibleQueryPresenter
]

{ #category : #tests }
MiNavigationQueriesPresenterTest >> testQueryValidity [

	self assert: presenter query isValid.

	(presenter directionRadioButtons detect: [ :rb | rb state not ])
		click.
	self assert: presenter query isValid.

	presenter associationCheckBoxes first click.
	self assert: presenter query isValid.

	presenter associationCheckBoxes first click.
	self assert: presenter query isValid.

	self resetPresenterWithEntities:
		helper entitiesWithNoIncomingAssociations.
	self deny: presenter query isValid.

	self resetPresenterWithEntities: helper noEntities.
	self deny: presenter query isValid
]

{ #category : #tests }
MiNavigationQueriesPresenterTest >> testRadioButtonsMatchAvailableDirections [

	| directions |
	directions := presenter query class directionStrategies.

	self
		assert: presenter directionRadioButtons size
		equals: directions size.

	self
		assertCollection: (presenter directionRadioButtons collect: #label)
		hasSameElements: (directions collect: #label)
]

{ #category : #tests }
MiNavigationQueriesPresenterTest >> testRadioButtonsMatchQuery [

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
MiNavigationQueriesPresenterTest >> testUpdateCreationBrowser [

	self assertCreationPresenterWasUpdated.

	(presenter directionRadioButtons detect: [ :rb | rb state not ])
		click.
	self assertCreationPresenterWasUpdated.

	presenter associationCheckBoxes first click.
	self assertCreationPresenterWasUpdated
]
