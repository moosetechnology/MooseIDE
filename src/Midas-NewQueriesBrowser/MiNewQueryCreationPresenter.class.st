Class {
	#name : #MiNewQueryCreationPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'#queryTypesDropListPresenter',
		'#queryConfigurationPresenter',
		'#parentPresenter',
		'#addButton',
		'#removeButton',
		'#query => SpObservableSlot'
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
	self notifyPropertyChanged: #query
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
	"queryConfigurationPresenter disable."
	addButton disable.
	removeButton disable
]

{ #category : #'api - actions' }
MiNewQueryCreationPresenter >> enable [

	queryTypesDropListPresenter enable.
	queryConfigurationPresenter enable.
	addButton enable.
	removeButton enable
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

{ #category : #initialization }
MiNewQueryCreationPresenter >> removeQueryAction [

	"parentPresenter removeQueryAction: self query"
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
		                     parentPresenter rootQuery.
	queryConfigurationPresenter := self instantiate:
		                               (MiQueryConfigurationPresenterFactory
			                                configureQuery: instantiatedQuery
			                                forOwnerPresenter: self).
	self update
]
