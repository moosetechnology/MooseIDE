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

{ #category : #actions }
MiNewQueryCreationPresenter >> addNewQueryAction [

	self disable.
	parentPresenter addNewQueryAction: self query.
	"Need to see if it is neccessary to inform query slot changed.
	For the moment, query SpObservable slot instance variable is not declared in MiNewQueriesBrowser.
	
	self notifyPropertyChanged: #query"
]

{ #category : #initialization }
MiNewQueryCreationPresenter >> connectPresenters [

	queryTypesDropListPresenter whenSelectedItemChangedDo: [ :queryClass | 
		self updateQueryConfigurationFor: queryClass ].
	"After setting whenSelectedItemChangedDo:, select the fastest query while we do not compute the results in a fork.
This is for instantiate queryConfigurationPresenter variable"
	queryTypesDropListPresenter selectIndex: 3.
	addButton action: [ self addNewQueryAction ].
	removeButton action: [ self removeQueryAction ]
]

{ #category : #'api - actions' }
MiNewQueryCreationPresenter >> disable [

	queryTypesDropListPresenter disable.
	self flag: 'TODO disable method on configuration presenter'.
	"queryConfigurationPresenter disable."
	addButton disable.
	"Do not call removeButton disable directly"
	self disableRemoveButton
]

{ #category : #actions }
MiNewQueryCreationPresenter >> disableRemoveButton [

	"If the button exists in the layout"

	removeButton ifNotNil: [ removeButton disable ]
]

{ #category : #'api - actions' }
MiNewQueryCreationPresenter >> enable [

	queryTypesDropListPresenter enable.
	self flag: 'TODO enable method on configuration presenter'.
	addButton enable.
	"queryConfigurationPresenter enable."
	"Do not call `removeButton enable` directly."
	self enableRemoveButton
]

{ #category : #actions }
MiNewQueryCreationPresenter >> enableRemoveButton [

	"If the button exists in the layout."

	removeButton ifNotNil: [ removeButton enable ]
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
	self initializeButtons
]

{ #category : #initialization }
MiNewQueryCreationPresenter >> initializeQueryTypesDropList [

	queryTypesDropListPresenter := self newDropList.
	queryTypesDropListPresenter
		items: self class queryTypes;
		display: [ :queryClass | queryClass label ]
]

{ #category : #accessing }
MiNewQueryCreationPresenter >> query [

	^ queryConfigurationPresenter query
]

{ #category : #'api - actions' }
MiNewQueryCreationPresenter >> removeButtonRemove [

	self layout remove: removeButton.
	"We do not want the removeButton to exist"
	removeButton := nil
]

{ #category : #initialization }
MiNewQueryCreationPresenter >> removeQueryAction [

	parentPresenter removeQueryAction: self query
]

{ #category : #'accessing model' }
MiNewQueryCreationPresenter >> setModelBeforeInitialization: aQueryBuilderPresenter [

	parentPresenter := aQueryBuilderPresenter
]

{ #category : #update }
MiNewQueryCreationPresenter >> updateFromConfiguration [

	parentPresenter queryChangedUpdate: self query
]

{ #category : #update }
MiNewQueryCreationPresenter >> updateQueryConfigurationFor: queryClass [

	| instantiatedQuery |
	instantiatedQuery := queryClass defaultForParent:
		                     parentPresenter currentQuery.
	queryConfigurationPresenter := self instantiate:
		                               (QueryConfigurationPresenterFactory
			                                configureQuery: instantiatedQuery
			                                forOwnerPresenter: self).
	self update
]
