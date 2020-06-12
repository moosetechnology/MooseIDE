Class {
	#name : #MiQueryConfigurationPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'query',
		'firstParameter',
		'secondParameter'
	],
	#category : #'Midas-FamixQueries-Presenters'
}

{ #category : #specs }
MiQueryConfigurationPresenter class >> addFirstParameterToLayout: defaultLayout [
	"Override for specific constraints"

	defaultLayout add: #firstParameter
]

{ #category : #specs }
MiQueryConfigurationPresenter class >> addSecondParameterToLayout: defaultLayout [
	"Override for specific constraints"

	defaultLayout add: #secondParameter
]

{ #category : #specs }
MiQueryConfigurationPresenter class >> defaultSpec [
	| defaultLayout |
	defaultLayout := SpBoxLayout newHorizontal.
	self addFirstParameterToLayout: defaultLayout.
	self addSecondParameterToLayout: defaultLayout.
	^ defaultLayout
]

{ #category : #running }
MiQueryConfigurationPresenter class >> queryClass [
	^ self subclassResponsibility
]

{ #category : #accessing }
MiQueryConfigurationPresenter class >> traitPrefix [
	^ 'FamixT'
]

{ #category : #update }
MiQueryConfigurationPresenter >> noParameterMessage: aParameterName [
	^ self instantiate: MiNoPossibleQueryPresenter on: aParameterName
]

{ #category : #transmissions }
MiQueryConfigurationPresenter >> notifyQueryChanged [
	owner updateFromConfiguration
]

{ #category : #accessing }
MiQueryConfigurationPresenter >> query [
	^ query
]

{ #category : #'accessing model' }
MiQueryConfigurationPresenter >> setModelBeforeInitialization: aQuery [
	query := aQuery
]

{ #category : #update }
MiQueryConfigurationPresenter >> updateForQuery: aQuery [
	query := aQuery
]
