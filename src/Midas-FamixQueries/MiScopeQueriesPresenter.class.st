Class {
	#name : #MiScopeQueriesPresenter,
	#superclass : #MiQueryConfigurationPresenter,
	#category : #'Midas-FamixQueries-Presenters'
}

{ #category : #specs }
MiScopeQueriesPresenter class >> addSecondParameterToLayout: defaultLayout [
	defaultLayout
		add:
			(SpBoxLayout newVertical
				add: #secondParameter
					expand: true
					fill: true
					padding: 50;
				yourself)
]

{ #category : #running }
MiScopeQueriesPresenter class >> queryClass [
	^ FQScopeQuery
]

{ #category : #specs }
MiScopeQueriesPresenter class >> title [
	^ 'Scope Query'
]

{ #category : #'widgets configuration' }
MiScopeQueriesPresenter >> configureRadioButton: radioButton forScopeDirection: direction [
	radioButton
		label: direction label;
		whenActivatedDo: [ self query resetAndChangeDirection: direction.
			self updateAccordingToDirection.
			self notifyQueryChanged ]
]

{ #category : #initialization }
MiScopeQueriesPresenter >> initializePresenters [
	self intializeDirectionRadioButtons.
	self initializeScopesDropList
]

{ #category : #initialization }
MiScopeQueriesPresenter >> initializeScopesDropList [
	self updateAccordingToDirection
]

{ #category : #initialization }
MiScopeQueriesPresenter >> intializeDirectionRadioButtons [
	firstParameter := SpDynamicPresentersListBuilder new
		modelObjects: self query directionStrategies;
		presenter: SpRadioButtonPresenter
			configuredAs:
				[ :radioButton :direction | self configureRadioButton: radioButton forScopeDirection: direction ];
		layoutBuilder: (SpDynamicTopToBottomRowsLayout rows: 1);
		build.
	firstParameter presenters first
		associatedRadioButtons: firstParameter presenters allButFirst.
	self selectCurrentQueryDirection
]

{ #category : #'widgets configuration' }
MiScopeQueriesPresenter >> scopesDropList [
	^ self newDropList
		items: self query availableScopes;
		display: [ :item | item mooseDescription name asEnglishPlural ];
		selectItem: self query scope;
		whenSelectedItemChangedDo: [ :scope | 
			scope ifNil: [ ^ self ].
			self query scope: scope.
			self notifyQueryChanged ]
]

{ #category : #initialization }
MiScopeQueriesPresenter >> selectCurrentQueryDirection [
	(firstParameter presenters
		detect: [ :radioButton | radioButton label = self query directionStrategy label ])
		state: true
]

{ #category : #update }
MiScopeQueriesPresenter >> updateAccordingToDirection [
	secondParameter := self query availableScopes
		ifNotEmpty: [ self scopesDropList ]
		ifEmpty: [ self noParameterMessage: 'scope' ].
	self update
]
