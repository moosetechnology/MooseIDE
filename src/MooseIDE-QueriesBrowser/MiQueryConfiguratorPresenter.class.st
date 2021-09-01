"
I am the abstract class for all the configuration presenter for the FamixQueries
"
Class {
	#name : #MiQueryConfiguratorPresenter,
	#superclass : #MiPresenter,
	#instVars : [
		'query'
	],
	#category : #'MooseIDE-QueriesBrowser-Configuration presenters'
}

{ #category : #specs }
MiQueryConfiguratorPresenter class >> defaultSpec [

	^ SpBoxLayout newHorizontal
]

{ #category : #layout }
MiQueryConfiguratorPresenter >> buildLayout [

	self layout: self class defaultSpec
]

{ #category : #actions }
MiQueryConfiguratorPresenter >> computeQuery: anObject [

	self subclassResponsibility
]

{ #category : #actions }
MiQueryConfiguratorPresenter >> computeQueryAction: anObject [

	[ owner enableProgressNotification ] asJob run.
	self computeQuery: anObject.
	self notifyQueryChanged.
	owner disableProgressNotification
]

{ #category : #initialization }
MiQueryConfiguratorPresenter >> initialize [

	super initialize.
	self buildLayout
]

{ #category : #update }
MiQueryConfiguratorPresenter >> noParameterMessage: aParameterName [

	^ self instantiate: MiNoPossibleQueryPresenter on: aParameterName
]

{ #category : #transmissions }
MiQueryConfiguratorPresenter >> notifyQueryChanged [

	owner queryChangedUpdate
]

{ #category : #accessing }
MiQueryConfiguratorPresenter >> query [
	^ query
]

{ #category : #'api - actions' }
MiQueryConfiguratorPresenter >> queryPresentersListChanged [

	"This method is trigerred when the list of queries presenters in MiQueryBuilderPresenter change. This can happen when the user adds or removes a new query from the queries list.
	The default behavior is to do nothing. This method must be overriden if a subclass wants to do something specific"

	"Maybe we should change this to use announcements"

	
]

{ #category : #'accessing - model' }
MiQueryConfiguratorPresenter >> setModelBeforeInitialization: aQuery [
	query := aQuery
]
