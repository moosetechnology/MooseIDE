Class {
	#name : #MiPropertyQueriesPresenter,
	#superclass : #MiQueryConfigurationPresenter,
	#category : #'Midas-FamixQueries-Presenters'
}

{ #category : #specs }
MiPropertyQueriesPresenter class >> addSecondParameterToLayout: defaultLayout [
	"Override for specific constraints"

	defaultLayout add: #secondParameter width: 200
]

{ #category : #accessing }
MiPropertyQueriesPresenter class >> propertyQueryTypes [
	^ {FQBooleanQuery.
	FQNumericQuery.
	FQStringQuery}
]

{ #category : #running }
MiPropertyQueriesPresenter class >> queryClass [
	^ FQPropertyQuery
]

{ #category : #specs }
MiPropertyQueriesPresenter class >> title [
	^ 'Property Query'
]

{ #category : #update }
MiPropertyQueriesPresenter >> configureBooleanQuery: aQuery [
	secondParameter := aQuery isValid
		ifTrue: [ self instantiate: MiBooleanQueryParametersPresenter ]
		ifFalse: [ self noParameterMessage: 'Boolean property' ]
]

{ #category : #update }
MiPropertyQueriesPresenter >> configureNumericQuery: aQuery [
	secondParameter := aQuery isValid
		ifTrue: [ self instantiate: MiNumericQueryParametersPresenter ]
		ifFalse: [ self noParameterMessage: 'Numeric property' ]
]

{ #category : #'widgets configuration' }
MiPropertyQueriesPresenter >> configureRadioButton: radioButton forQueryClass: queryClass [
	radioButton
		label: queryClass label substrings first;
		whenActivatedDo: [ self updateForQuery: (queryClass defaultForParent: query parent) ]
]

{ #category : #update }
MiPropertyQueriesPresenter >> configureStringQuery: aQuery [
	secondParameter := aQuery isValid
		ifTrue: [ self instantiate: MiStringQueryParametersPresenter ]
		ifFalse: [ self noParameterMessage: 'String property' ]
]

{ #category : #initialization }
MiPropertyQueriesPresenter >> initializePresenters [
	self initializeQueryTypeRadioButtons.
	query configureIn: self
]

{ #category : #initialization }
MiPropertyQueriesPresenter >> initializeQueryTypeRadioButtons [
	firstParameter := SpDynamicPresentersListBuilder new
		modelObjects: self class propertyQueryTypes;
		presenter: SpRadioButtonPresenter
			configuredAs:
				[ :radioButton :queryClass | self configureRadioButton: radioButton forQueryClass: queryClass ];
		layoutBuilder: (SpDynamicTopToBottomRowsLayout rows: 1);
		build.
	firstParameter presenters first
		associatedRadioButtons: firstParameter presenters allButFirst
]

{ #category : #update }
MiPropertyQueriesPresenter >> updateForQuery: aQuery [
	aQuery ~= query
		ifTrue: [ query := aQuery.
			aQuery configureIn: self ].
	self update.
	self notifyQueryChanged
]
