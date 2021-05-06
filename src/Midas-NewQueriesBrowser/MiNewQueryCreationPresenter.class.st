Class {
	#name : #MiNewQueryCreationPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'queryTypesDropListPresenter',
		'parentBrowser',
		'queryConfigurationPresenter'
	],
	#category : #'Midas-NewQueriesBrowser-Subpresenters'
}

{ #category : #specs }
MiNewQueryCreationPresenter class >> defaultSpec [

	^ (SpBoxLayout newTopToBottom
			 add: #queryTypesDropListPresenter;
			 add: #queryConfigurationPresenter;
			 yourself)
]

{ #category : #accessing }
MiNewQueryCreationPresenter class >> queryTypes [

	^ FQUnaryQuery allSubclasses select: #canBeConfigured
	"sort: #name ascending"
]

{ #category : #initialization }
MiNewQueryCreationPresenter >> initializeLayout [

	self layout: (SpBoxLayout newTopToBottom
			 add: #queryTypesDropListPresenter;
			 add: #queryConfigurationPresenter;
			 yourself)
]

{ #category : #initialization }
MiNewQueryCreationPresenter >> initializePresenters [

	self initializeQueryTypesDropList
]

{ #category : #initialization }
MiNewQueryCreationPresenter >> initializeQueryTypesDropList [

	queryTypesDropListPresenter := self newDropList.
	queryTypesDropListPresenter
		items: self class queryTypes;
		display: [ :queryClass | queryClass label ];
		whenSelectedItemChangedDo: [ :queryClass | 
			self updateQueryConfigurationFor: queryClass ].
	queryTypesDropListPresenter selectIndex: 3 "Select the fastest query while we do not compute the results in a fork"
]

{ #category : #'accessing model' }
MiNewQueryCreationPresenter >> setModelBeforeInitialization: aQueriesBrowserPresenter [

	parentBrowser := aQueriesBrowserPresenter
]

{ #category : #'accessing model' }
MiNewQueryCreationPresenter >> updateQueryConfigurationFor: queryClass [

	| instantiatedQuery |
	instantiatedQuery := queryClass defaultForParent:
		                     parentBrowser currentQuery.
	queryConfigurationPresenter := self instantiate:
		                               (MiQueryConfigurationPresenterFactory
			                                configureQuery: instantiatedQuery
			                                forOwnerPresenter: self).
	self update
]
