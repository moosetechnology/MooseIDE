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
		'addButton',
		'removeButton',
		'parentQuery',
		'parentPresenter'
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
	parentPresenter addNewQueryAction: self query
	"Need to see if it is neccessary to inform query slot changed.
	For the moment, query SpObservable slot instance variable is not declared in MiNewQueriesBrowser.
	
	self notifyPropertyChanged: #query"
]

{ #category : #'api - actions' }
MiNewQueryCreationPresenter >> disable [

	queryTypesDropListPresenter disable.
	self flag: 'TODO disable method on configuration presenter'
	"queryConfigurationPresenter disable."
]

{ #category : #'api - actions' }
MiNewQueryCreationPresenter >> enable [

	queryTypesDropListPresenter enable.
	self flag: 'TODO enable method on configuration presenter'.
	"queryConfigurationPresenter enable."
]

{ #category : #initialization }
MiNewQueryCreationPresenter >> indentationSpacesPresenters [

	"Returns a collection with blank images to show the level of indentation that the query has"

	| indentationPresenters indentationLevel |
	indentationLevel := parentQuery parentSequence size - 1.
	indentationPresenters := OrderedCollection empty.
	indentationLevel timesRepeat: [ 
		indentationPresenters add: (SpImagePresenter new
				 image: ((self iconNamed: #blank) scaledToSize: 10 @ 10);
				 yourself) ].
	^ indentationPresenters
]

{ #category : #initialization }
MiNewQueryCreationPresenter >> initializeButtons [

	addButton := self newButton.
	addButton
		icon: (self iconNamed: #smallAdd);
		action: [ self addNewQueryAction ].
	removeButton := self newButton.
	removeButton
		icon: (self iconNamed: #remove);
		action: [ self removeQueryAction ]
]

{ #category : #initialization }
MiNewQueryCreationPresenter >> initializeLayout [

	| buttonConstraints tempLayout |
	buttonConstraints := [ :constraints | 
	                     constraints
		                     width: self class iconWidth;
		                     expand: false ].
	tempLayout := SpBoxLayout newLeftToRight
		              spacing: 5;
		              borderWidth: 5;
		              yourself.
	self indentationSpacesPresenters do: [ :each | 
		tempLayout add: each expand: false ].
	tempLayout
		add: #queryTypesDropListPresenter width: 130;
		add: #queryConfigurationPresenter;
		addLast: #addButton withConstraints: buttonConstraints;
		addLast: #removeButton withConstraints: buttonConstraints.
	self layout: tempLayout
]

{ #category : #initialization }
MiNewQueryCreationPresenter >> initializePresenters [

	self initializeLayout.
	self initializeButtons.
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
	"After setting whenSelectedItemChangedDo:, select the fastest query while we do not compute the
	results in a fork.
	This is for instantiate queryConfigurationPresenter variable"
	"Changed, initially was typeQuery (selectIndex: 3)"
	queryTypesDropListPresenter selectItem: FQStringQuery
]

{ #category : #accessing }
MiNewQueryCreationPresenter >> parentPresenter: aMiQueryBuilderPresenter [

	parentPresenter := aMiQueryBuilderPresenter
]

{ #category : #accessing }
MiNewQueryCreationPresenter >> query [

	^ queryConfigurationPresenter
		  ifNotNil: [ queryConfigurationPresenter query ]
		  ifNil: [ nil ]
]

{ #category : #accessing }
MiNewQueryCreationPresenter >> queryConfigurationPresenter [

	^ queryConfigurationPresenter
]

{ #category : #'api - actions' }
MiNewQueryCreationPresenter >> removeButtonRemove [

	"We do not want the removeButton to exist"

	self layout remove: removeButton.
	removeButton := nil
]

{ #category : #actions }
MiNewQueryCreationPresenter >> removeQueryAction [

	parentPresenter removeQueryAction: self
]

{ #category : #'accessing model' }
MiNewQueryCreationPresenter >> setModelBeforeInitialization: aQuery [

	parentQuery := aQuery
]

{ #category : #'api - actions' }
MiNewQueryCreationPresenter >> updateFromConfiguration [

	parentPresenter queryChangedUpdate: self query
]

{ #category : #update }
MiNewQueryCreationPresenter >> updateQueryConfigurationFor: queryClass [

	| newQuery miConfigurationPresenterClass |
	"Create the new query"
	(parentQuery children includes: self query) ifTrue: [ 
		parentQuery removeChild: self query ].
	newQuery := queryClass defaultForParent: parentQuery.
	parentQuery addChild: newQuery.

	"Instantiate the configuration presenter with the new created query"
	miConfigurationPresenterClass := newQuery miPresenterClass.
	queryConfigurationPresenter := self instantiate:
		                               (miConfigurationPresenterClass
			                                owner: self
			                                on: newQuery).
	self update
]
