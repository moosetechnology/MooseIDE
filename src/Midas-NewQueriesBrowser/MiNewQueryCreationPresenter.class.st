Class {
	#name : #MiNewQueryCreationPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'queryTypesDropListPresenter',
		'queryConfigurationPresenter',
		'parentPresenter',
		'addButton',
		'removeButton'
	],
	#category : #'Midas-NewQueriesBrowser-Sub presenters'
}

{ #category : #specs }
MiNewQueryCreationPresenter class >> defaultSpec [

	^ SpBoxLayout newLeftToRight
		  spacing: 5;
		  borderWidth: 5;
		  add: #queryTypesDropListPresenter
		  withConstraints: [ :constraints | 
			  constraints
				  height: self toolbarHeight;
				  expand: false ];
		  add: #queryConfigurationPresenter
		  withConstraints: [ :constraints | 
		  constraints height: self toolbarHeight ];
		  addLast: #addButton withConstraints: [ :constraints | 
		  constraints
			  height: self toolbarHeight;
			  width: self iconWidth;
			  expand: false ];
		  addLast: #removeButton withConstraints: [ :constraints | 
		  constraints
			  height: self toolbarHeight;
			  width: self iconWidth;
			  expand: false ];
		  yourself
]

{ #category : #accessing }
MiNewQueryCreationPresenter class >> queryTypes [

	^ FQUnaryQuery allSubclasses select: #canBeConfigured
	"sort: #name ascending"
]

{ #category : #update }
MiNewQueryCreationPresenter >> addNewQuery [

	parentPresenter addChildToQuery: self query
]

{ #category : #initialization }
MiNewQueryCreationPresenter >> initializeButtons [

	addButton := self newButton
		             icon: (self iconNamed: #smallAdd);
		             yourself.
	removeButton := self newButton
		                icon: (self iconNamed: #remove);
		                yourself
]

{ #category : #initialization }
MiNewQueryCreationPresenter >> initializePresenters [

	self initializeQueryTypesDropList.
	self initializeButtons.
	"Select the fastest query while we do not compute the results in a fork"
	queryTypesDropListPresenter selectIndex: 3
]

{ #category : #initialization }
MiNewQueryCreationPresenter >> initializeQueryTypesDropList [

	queryTypesDropListPresenter := self newDropList.
	queryTypesDropListPresenter
		items: self class queryTypes;
		display: [ :queryClass | queryClass label ];
		whenSelectedItemChangedDo: [ :queryClass | 
			self updateQueryConfigurationFor: queryClass
			"parentPresenter updateLayout" ];
		whenBuiltDo: [ "Select the fastest query while we do not compute the results in a fork""queryTypesDropListPresenter selectIndex: 3"
			 ]
]

{ #category : #update }
MiNewQueryCreationPresenter >> query [

	^ queryConfigurationPresenter query
]

{ #category : #'accessing model' }
MiNewQueryCreationPresenter >> setModelBeforeInitialization: aQueryBuilderPresenter [

	parentPresenter := aQueryBuilderPresenter
]

{ #category : #update }
MiNewQueryCreationPresenter >> updateFromConfiguration [

	parentPresenter updateQueryBrowserResultListEntities:
		self query result.
	parentPresenter updateQueryBrowserCodePresenter: self query
]

{ #category : #update }
MiNewQueryCreationPresenter >> updateQueryConfigurationFor: queryClass [

	| instantiatedQuery |
	instantiatedQuery := queryClass defaultForParent:
		                     parentPresenter currentQuery.
	queryConfigurationPresenter := self instantiate:
		                               (MiQueryConfigurationPresenterFactory
			                                configureQuery: instantiatedQuery
			                                forOwnerPresenter: self).
	self update
]
