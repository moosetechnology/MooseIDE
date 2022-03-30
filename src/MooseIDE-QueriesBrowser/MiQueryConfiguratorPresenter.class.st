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

{ #category : #actions }
MiQueryConfiguratorPresenter >> computeQuery: anObject [

	self subclassResponsibility
]

{ #category : #actions }
MiQueryConfiguratorPresenter >> computeQueryAction: anObject [

	[ owner enableProgressNotification ] asJob run.
	self computeQuery: anObject.
	self root application consumeItem: query.
	self notifyQueryChanged.
	owner disableProgressNotification
]

{ #category : #'api - actions' }
MiQueryConfiguratorPresenter >> configureFor: aQuery [

	"You should always do `query := aQuery` at the end of this method for all subclasses"

	self subclassResponsibility
]

{ #category : #layout }
MiQueryConfiguratorPresenter >> initializeLayout [

	self layout: self newLayout
]

{ #category : #testing }
MiQueryConfiguratorPresenter >> isQueryUsed: aQuery [

	^ false
]

{ #category : #layout }
MiQueryConfiguratorPresenter >> newLayout [

	self subclassResponsibility
]

{ #category : #update }
MiQueryConfiguratorPresenter >> noParameterMessage: aParameterName [

	^ self instantiate: NoPossibleQueryPresenter on: aParameterName
]

{ #category : #transmissions }
MiQueryConfiguratorPresenter >> notifyQueryChanged [

	owner queryChangedUpdate
]

{ #category : #accessing }
MiQueryConfiguratorPresenter >> queriesBrowser [

	^ owner queriesBrowser
]

{ #category : #accessing }
MiQueryConfiguratorPresenter >> query [
	^ query
]

{ #category : #'accessing - model' }
MiQueryConfiguratorPresenter >> setModelBeforeInitialization: aQuery [
	query := aQuery
]
