"
I allow to filter a MooseModel depending on the query that you choose. I have a dropdown list that has all the existing query types. When you select some query type, a configuration presenter is created. This configuration presenter is specific for each type of query.

I manage all the logic related of changing dynamically this configuration presenter. Also, I send a message to my parentPresenter (`MiQueryBuilderPresenter`) each time my add or remove button is pressed.
"
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
	#category : #'Midas-NewTools-Queries Browser'
}

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
This is for instantiate queryConfigurationPresenter variable" "changed to string query initialize was typequery"
	queryTypesDropListPresenter selectItem: FQStringQuery.
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
MiNewQueryCreationPresenter >> initializeLayout [

	| buttonConstraints |
	buttonConstraints := [ :constraints | 
	                     constraints
		                     width: self class iconWidth;
		                     expand: false ].
	self layout: (SpBoxLayout newLeftToRight
			 spacing: 5;
			 borderWidth: 5;
			 add: #queryTypesDropListPresenter expand: false;
			 add: #queryConfigurationPresenter;
			 addLast: #addButton withConstraints: buttonConstraints;
			 addLast: #removeButton withConstraints: buttonConstraints;
			 yourself)
]

{ #category : #initialization }
MiNewQueryCreationPresenter >> initializePresenters [

	self initializeLayout.
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

{ #category : #'as yet unclassified' }
MiNewQueryCreationPresenter >> parentPresenter [
	^ parentPresenter
]

{ #category : #accessing }
MiNewQueryCreationPresenter >> query [

	^ queryConfigurationPresenter query
]

{ #category : #'as yet unclassified' }
MiNewQueryCreationPresenter >> queryConfigurationPresenter [

	^ queryConfigurationPresenter
]

{ #category : #'api - actions' }
MiNewQueryCreationPresenter >> removeButtonRemove [

	"We do not want the removeButton to exist"

	self layout remove: removeButton.
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

{ #category : #'api - actions' }
MiNewQueryCreationPresenter >> updateFromConfiguration [

	parentPresenter queryChangedUpdate: self query
]

{ #category : #update }
MiNewQueryCreationPresenter >> updateQueryConfigurationFor: queryClass [

	| instantiatedQuery miConfigurationPresenterClass |
	instantiatedQuery := queryClass defaultForParent:
		                     parentPresenter currentQuery.
	miConfigurationPresenterClass := instantiatedQuery miPresenterClass.
	queryConfigurationPresenter := self instantiate:
		                               (miConfigurationPresenterClass
			                                owner: self
			                                on: instantiatedQuery).
	self update
]
