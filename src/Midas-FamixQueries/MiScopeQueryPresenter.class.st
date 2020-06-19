Class {
	#name : #MiScopeQueryPresenter,
	#superclass : #MiQueryConfigurationPresenter,
	#category : #'Midas-FamixQueries-QueriesConfiguration'
}

{ #category : #specs }
MiScopeQueryPresenter class >> addSecondParameterToLayout: defaultLayout [
	defaultLayout
		add:
			(SpBoxLayout newVertical
				add: #secondParameter
					expand: true
					fill: true
					padding: 50;
				yourself)
]

{ #category : #specs }
MiScopeQueryPresenter class >> title [
	^ 'Scope Query'
]

{ #category : #'widgets configuration' }
MiScopeQueryPresenter >> configureRadioButton: radioButton forScopeDirection: direction [
	radioButton
		label: direction label;
		whenActivatedDo: [ self query resetAndChangeDirection: direction.
			self updateAccordingToDirection.
			self notifyQueryChanged ]
]

{ #category : #initialization }
MiScopeQueryPresenter >> initializePresenters [
	self intializeDirectionRadioButtons.
	self initializeScopesDropList
]

{ #category : #initialization }
MiScopeQueryPresenter >> initializeScopesDropList [
	self updateAccordingToDirection
]

{ #category : #initialization }
MiScopeQueryPresenter >> intializeDirectionRadioButtons [
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
MiScopeQueryPresenter >> scopesDropList [
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
MiScopeQueryPresenter >> selectCurrentQueryDirection [
	(firstParameter presenters
		detect: [ :radioButton | radioButton label = self query directionStrategy label ])
		state: true
]

{ #category : #update }
MiScopeQueryPresenter >> updateAccordingToDirection [
	secondParameter := self query availableScopes
		ifNotEmpty: [ self scopesDropList ]
		ifEmpty: [ self noParameterMessage: 'scope' ].
	self update
]
