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

	^ SpBoxLayout newLeftToRight
		  add: #queryTypesDropListPresenter expand: false;
		  add: #queryConfigurationPresenter;
		  yourself
]

{ #category : #accessing }
MiNewQueryCreationPresenter class >> queryTypes [

	^ FQUnaryQuery allSubclasses select: #canBeConfigured
	"sort: #name ascending"
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
			self updateQueryConfigurationFor: queryClass ];
		whenBuiltDo: [ "Select the fastest query while we do not compute the results in a fork""queryTypesDropListPresenter selectIndex: 3"
			 ].
	"Select the fastest query while we do not compute the results in a fork"
	queryTypesDropListPresenter selectIndex: 3.
	queryTypesDropListPresenter selectIndex: 3.
	queryTypesDropListPresenter selectIndex: 3.
	queryTypesDropListPresenter selectIndex: 3.
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
