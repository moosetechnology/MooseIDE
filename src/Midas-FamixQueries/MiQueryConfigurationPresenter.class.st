Class {
	#name : #MiQueryConfigurationPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'query'
	],
	#category : #'Midas-FamixQueries-QueriesConfiguration'
}

{ #category : #specs }
MiQueryConfigurationPresenter class >> defaultSpec [

	^ SpBoxLayout newHorizontal
]

{ #category : #layout }
MiQueryConfigurationPresenter >> buildLayout [

	self layout: self class defaultSpec
]

{ #category : #api }
MiQueryConfigurationPresenter >> disable [

	self presenters do: [ :subPresenter | subPresenter disable ]
]

{ #category : #api }
MiQueryConfigurationPresenter >> enable [

	self presenters do: [ :subPresenter | subPresenter enable ]
]

{ #category : #accessing }
MiQueryConfigurationPresenter >> initialize [

	super initialize.
	self buildLayout
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
