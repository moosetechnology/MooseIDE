Class {
	#name : #MiPropertyQueriesPresenterTest,
	#superclass : #MiQueryConfigurationPresenterTest,
	#category : #'Midas-FamixQueries-Tests-Presenters'
}

{ #category : #running }
MiPropertyQueriesPresenterTest >> classToTest [
	^ MiPropertyQueriesPresenter
]

{ #category : #running }
MiPropertyQueriesPresenterTest >> queryClass [
	^ FQPropertyQuery
]

{ #category : #accessing }
MiPropertyQueriesPresenterTest >> radioButtons [
	^ presenter firstParameter presenters
		reject: [ :pres | pres class = SpNullPresenter ]
]

{ #category : #tests }
MiPropertyQueriesPresenterTest >> testFirstParameter [
	self assert:
		(presenter firstParameter presenters
			allSatisfy: [ :pres | pres class == SpRadioButtonPresenter ]).

	self resetPresenterWithEntities: helper noEntities.
	self assert:
		(presenter firstParameter presenters
			allSatisfy: [ :pres | pres class == SpRadioButtonPresenter ])
]

{ #category : #tests }
MiPropertyQueriesPresenterTest >> testNoAvailableProperties [
	self resetPresenterWithEntities: helper noEntities.
	(self radioButtons detect: [ :rb | rb label = 'Numeric' ]) click.
	self
		assert: presenter secondParameter class
		identicalTo: MiNoPossibleQueryPresenter.
	(self radioButtons detect: [ :rb | rb label = 'String' ]) click.
	self
		assert: presenter secondParameter class
		identicalTo: MiNoPossibleQueryPresenter.
	(self radioButtons detect: [ :rb | rb label = 'Boolean' ]) click.
	self
		assert: presenter secondParameter class
		identicalTo: MiNoPossibleQueryPresenter
]

{ #category : #tests }
MiPropertyQueriesPresenterTest >> testQueryBuilderType [
	(self radioButtons detect: [ :rb | rb label ='Boolean' ]) click.
	self assert: presenter secondParameter class identicalTo: MiBooleanQueryParametersPresenter.
	
	(self radioButtons detect: [ :rb | rb label ='Numeric' ]) click.
	self assert: presenter secondParameter class identicalTo: MiNumericQueryParametersPresenter.
	
	(self radioButtons detect: [ :rb | rb label ='String' ]) click.
	self assert: presenter secondParameter class identicalTo: MiStringQueryParametersPresenter
]

{ #category : #tests }
MiPropertyQueriesPresenterTest >> testQueryType [
	(self radioButtons detect: [ :rb | rb label ='Boolean' ]) click.
	self assert: presenter query class identicalTo: FQBooleanQuery.
	
	(self radioButtons detect: [ :rb | rb label ='Numeric' ]) click.
	self assert: presenter query class identicalTo: FQNumericQuery.
	
	(self radioButtons detect: [ :rb | rb label ='String' ]) click.
	self assert: presenter query class identicalTo: FQStringQuery.
]

{ #category : #tests }
MiPropertyQueriesPresenterTest >> testQueryValidity [
	self assert: presenter query isValid.
	
	(self radioButtons detect: [ :rb | rb state not ]) click.
	self assert: presenter query isValid.
	
	self resetPresenterWithEntities: helper noEntities.
	self deny: presenter query isValid
]

{ #category : #tests }
MiPropertyQueriesPresenterTest >> testRadioButtonsMatchQuery [
	| initialQueryClass |
	initialQueryClass := self currentQuery class.
	self
		assert: (self radioButtons detect: #state) label
		equals: initialQueryClass label substrings first.
	
	(self radioButtons detect: [ :rb | rb state not ]) click.
	
	self
		assert: (self radioButtons detect: #state) label
		equals: self currentQuery class label substrings first.
	self deny: self currentQuery class identicalTo: initialQueryClass
]

{ #category : #tests }
MiPropertyQueriesPresenterTest >> testSecondParameter [
	self
		assert: presenter secondParameter query class label substrings first
		equals: (self radioButtons detect: #state) label.
	
	self resetPresenterWithEntities: helper noEntities.
	self
		assert: presenter secondParameter class
		identicalTo: MiNoPossibleQueryPresenter
]

{ #category : #tests }
MiPropertyQueriesPresenterTest >> testSubPresenterMatchesRadioButton [
	| initialQueryClass |
	
	initialQueryClass := presenter query class.
	self
		assert: presenter secondParameter query class
		equals: initialQueryClass.
	
	(self radioButtons detect: [ :rb | rb state not ]) click.
	
	self deny: presenter query class equals: initialQueryClass.
	self
		assert: presenter secondParameter query class
		equals: presenter query class.
]

{ #category : #tests }
MiPropertyQueriesPresenterTest >> testUpdateCreationBrowser [
	self assertCreationPresenterWasUpdated.
	(self radioButtons detect: [ :rb | rb state not ]) click.
	self assertCreationPresenterWasUpdated
]
