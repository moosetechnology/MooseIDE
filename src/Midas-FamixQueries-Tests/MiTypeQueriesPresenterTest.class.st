Class {
	#name : #MiTypeQueriesPresenterTest,
	#superclass : #MiQueryConfigurationPresenterTest,
	#category : #'Midas-FamixQueries-Tests-QueriesConfiguration'
}

{ #category : #accessing }
MiTypeQueriesPresenterTest >> checkBoxes [
	^ presenter secondParameter presenters
		reject: [ :pres | pres class = SpNullPresenter ]
]

{ #category : #running }
MiTypeQueriesPresenterTest >> classToTest [
	^ MiTypeQueryPresenter
]

{ #category : #running }
MiTypeQueriesPresenterTest >> queryClass [
	^ FQTypeQuery
]

{ #category : #tests }
MiTypeQueriesPresenterTest >> testCheckBoxesChangeQueryTypes [
	| initialSize |
	initialSize := self currentQuery types size.
	
	self checkBoxes first click.
	self assert: self currentQuery types size equals: initialSize - 1.
	
	self checkBoxes first click.
	self assert: self currentQuery types size equals: initialSize
]

{ #category : #tests }
MiTypeQueriesPresenterTest >> testCheckBoxesDisabledWhenOnlyOneChecked [
	self resetPresenterWithEntities: helper modelExample allModelClasses.

	"Only 1 type in the query, cannot be removed, so the checkBox is disabled"
	self deny: self checkBoxes first isEnabled.
	self assert: self checkBoxes first state
]

{ #category : #tests }
MiTypeQueriesPresenterTest >> testCheckBoxesMatchAvailableTypes [
	| types |
	types := presenter query availableTypes.
	self assert: self checkBoxes size equals: types size.
	self
		assertCollection:
			(types
				collect: [ :type | type name asEnglishPlural withoutPrefix: 'FamixSt' ])
		hasSameElements: (self checkBoxes collect: #label)
]

{ #category : #tests }
MiTypeQueriesPresenterTest >> testCheckBoxesMatchQuery [
	| currentQueryTypes |
	
	self checkBoxes first click.
	
	currentQueryTypes := self currentQuery types
		collect: [ :type | type name asEnglishPlural withoutPrefix: 'FamixSt' ].
	
	self
		assertCollection: currentQueryTypes
		hasSameElements: (self checkBoxes select: #state thenCollect: #label).
	
	self
		denyCollection: currentQueryTypes
		hasSameElements: (self checkBoxes reject: #state thenCollect: #label)
]

{ #category : #tests }
MiTypeQueriesPresenterTest >> testFirstParameter [
	self
		assert: presenter firstParameter class
		identicalTo: SpNullPresenter.
		
	self resetPresenterWithEntities: helper noEntities.
	self
		assert: presenter firstParameter class
		identicalTo: SpNullPresenter.
]

{ #category : #tests }
MiTypeQueriesPresenterTest >> testLastCheckBoxeDisabled [	
	self checkBoxes first click.
	self assert: self checkBoxes first isEnabled.
	self deny: self checkBoxes first state.
	
	"Only 1 type in the query, cannot be removed, so the checkBox is disabled"
	self deny: self checkBoxes second isEnabled.
	self assert: self checkBoxes second state.
	
	self checkBoxes first click.
	"Two types in the query, so one of them can be removed. All checkboxes are enabled"
	self assert: self checkBoxes first isEnabled.
	self assert: self checkBoxes first state.
	self assert: self checkBoxes second isEnabled.
	self assert: self checkBoxes second state.
]

{ #category : #tests }
MiTypeQueriesPresenterTest >> testQueryValidity [
	self assert: presenter query isValid.

	self checkBoxes first click.
	self assert: presenter query isValid.

	self checkBoxes first click.
	self assert: presenter query isValid.

	self resetPresenterWithEntities: helper noEntities.
	self deny: presenter query isValid
]

{ #category : #tests }
MiTypeQueriesPresenterTest >> testSecondParameter [
	self assert:
		(presenter secondParameter presenters
			allSatisfy:
				[ :pres | pres class == SpCheckBoxPresenter 
				"Could be some SpNullPresenter depending on the dynamic layout 
				but it is not the case here, since there is only 2 types"
				and: [ pres state ] ]).
				
	self resetPresenterWithEntities: helper noEntities.
	self
		assert: presenter secondParameter class
		identicalTo: MiNoPossibleQueryPresenter
]

{ #category : #tests }
MiTypeQueriesPresenterTest >> testUpdateCreationBrowser [
	self assertCreationPresenterWasUpdated.
	self checkBoxes first click.
	self assertCreationPresenterWasUpdated
]
