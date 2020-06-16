Class {
	#name : #MiNavigationQueriesPresenterTest,
	#superclass : #MiQueryConfigurationPresenterTest,
	#category : #'Midas-FamixQueries-Tests-Presenters'
}

{ #category : #running }
MiNavigationQueriesPresenterTest >> assertCheckBoxesMatchAvailableAssociations [
	| availableAssociations |
	availableAssociations := presenter query availableAssociations.
	self assert: self checkBoxes size equals: availableAssociations size.
	self
		assert: (self checkBoxes select: #state) size
		equals: availableAssociations size.
	self
		assertCollection:
			(availableAssociations
				collect: [ :assoc | assoc mooseDescription name asString ])
		hasSameElements: (self checkBoxes select: #state thenCollect: #label)
]

{ #category : #running }
MiNavigationQueriesPresenterTest >> assertCheckBoxesMatchQuery [
	self
		assertCollection:
			(presenter query associations
				collect: [ :type | type mooseDescription name asString ])
		hasSameElements: (self checkBoxes select: #state thenCollect: #label).
		
	(self radioButtons detect: [ :rb | rb state not ]) click.
	
	self
		assertCollection:
			(presenter query associations
				collect: [ :type | type mooseDescription name asString ])
		hasSameElements: (self checkBoxes select: #state thenCollect: #label)
]

{ #category : #accessing }
MiNavigationQueriesPresenterTest >> checkBoxes [
	^ presenter secondParameter presenters
		reject: [ :pres | pres class = SpNullPresenter ]
]

{ #category : #running }
MiNavigationQueriesPresenterTest >> classToTest [
	^ MiNavigationQueriesPresenter
]

{ #category : #running }
MiNavigationQueriesPresenterTest >> queryClass [
	^ FQNavigationQuery
]

{ #category : #accessing }
MiNavigationQueriesPresenterTest >> radioButtons [
	^ presenter firstParameter presenters
		reject: [ :pres | pres class = SpNullPresenter ]
]

{ #category : #tests }
MiNavigationQueriesPresenterTest >> testCheckBoxesDisabledWhenOnlyOneChecked [
	self resetPresenterWithEntities: helper methods.
	(self radioButtons
		detect: [ :radioButton | radioButton label = 'Local Incoming' ])
		click.

	"Only 1 association in the query, cannot be removed, so all checkBoxes are disabled"
	self checkBoxes do: [ :cb | self deny: cb isEnabled ].
	self assert: (self checkBoxes select: #state) size equals: 1
]

{ #category : #tests }
MiNavigationQueriesPresenterTest >> testCheckBoxesMatchAssociations [
	self assertCheckBoxesMatchAvailableAssociations.
	self assertCheckBoxesMatchQuery.
	(self radioButtons detect: [ :rb | rb state not ]) click.
	self assertCheckBoxesMatchAvailableAssociations.
	self assertCheckBoxesMatchQuery
]

{ #category : #tests }
MiNavigationQueriesPresenterTest >> testFirstParameter [
	self assert:
		(presenter firstParameter presenters
			allSatisfy: [ :pres | pres class == SpRadioButtonPresenter ]).

	self resetPresenterWithEntities: helper noEntities.
	self assert:
		(presenter firstParameter presenters
			allSatisfy: [ :pres | pres class == SpRadioButtonPresenter ])
]

{ #category : #tests }
MiNavigationQueriesPresenterTest >> testQueryValidity [
	self assert: presenter query isValid.
	
	(self radioButtons detect: [ :rb | rb state not ]) click.
	self assert: presenter query isValid.
	
	self checkBoxes first click.
	self assert: presenter query isValid.

	self checkBoxes first click.
	self assert: presenter query isValid.
	
	self resetPresenterWithEntities: helper entitiesWithNoIncomingAssociations.
	self deny: presenter query isValid.
	
	self resetPresenterWithEntities: helper noEntities.
	self deny: presenter query isValid.
]

{ #category : #tests }
MiNavigationQueriesPresenterTest >> testRadioButtonsMatchAvailableDirections [
	| directions |
	directions := presenter query class directionStrategies.
	
	self assert: self radioButtons size equals: directions size.
	
	self
		assertCollection: (self radioButtons collect: #label)
		hasSameElements: (directions collect: #label)
]

{ #category : #tests }
MiNavigationQueriesPresenterTest >> testRadioButtonsMatchQuery [
	self
		assert: (self radioButtons detect: #state) label
		equals: self currentQuery directionStrategy label.
	
	(self radioButtons detect: [ :rb | rb state not ]) click.
	self
		assert: (self radioButtons detect: #state) label
		equals: self currentQuery directionStrategy label
]

{ #category : #tests }
MiNavigationQueriesPresenterTest >> testSecondParameter [
	self assert:
		(presenter secondParameter presenters
			allSatisfy: [ :pres | 
				pres class == SpCheckBoxPresenter
				"Could be some SpNullPresenter depending on the dynamic layout 
				but it is not the case here" ]).

	self resetPresenterWithEntities: helper noEntities.
	self
		assert: presenter secondParameter class
		identicalTo: MiNoPossibleQueryPresenter
]

{ #category : #tests }
MiNavigationQueriesPresenterTest >> testUpdateCreationBrowser [
	self assertCreationPresenterWasUpdated.
	
	(self radioButtons detect: [ :rb | rb state not ]) click.
	self assertCreationPresenterWasUpdated.

	self checkBoxes first click.
	self assertCreationPresenterWasUpdated
]
