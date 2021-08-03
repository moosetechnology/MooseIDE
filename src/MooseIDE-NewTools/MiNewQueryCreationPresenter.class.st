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
		'parentQuery',
		'parentPresenter',
		'queryNumber',
		'queryNumberLabelPresenter',
		'optionsMenuButton'
	],
	#category : #'MooseIDE-NewTools-Queries Browser'
}

{ #category : #'instance creation' }
MiNewQueryCreationPresenter class >> on: aModel parentPresenter: aPresenter [

	^ self basicNew
		  application: self currentApplication;
		  setModelBeforeInitialization: aModel;
		  parentPresenter: aPresenter;
		  initialize;
		  yourself
]

{ #category : #'instance creation' }
MiNewQueryCreationPresenter class >> on: aModel parentPresenter: aPresenter queryNumber: aNumber [

	^ self basicNew
		  application: self currentApplication;
		  setModelBeforeInitialization: aModel;
		  parentPresenter: aPresenter;
		  queryNumber: aNumber;
		  initialize;
		  yourself
]

{ #category : #actions }
MiNewQueryCreationPresenter >> addNewChildQueryAction [

	parentPresenter addNewChildQueryAction: self query
	"We need to see if after adding a new query we have to disable this one."
]

{ #category : #accessing }
MiNewQueryCreationPresenter >> allQueryPresenters [

	^ parentPresenter creationPresenters
]

{ #category : #'api - actions' }
MiNewQueryCreationPresenter >> disableProgressNotification [

	parentPresenter disableProgressNotification
]

{ #category : #'api - actions' }
MiNewQueryCreationPresenter >> enableProgressNotification [

	parentPresenter enableProgressNotification
]

{ #category : #accessing }
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

	| optionsMenuGroup |
	optionsMenuGroup := self newMenu.
	optionsMenuGroup addGroup: [ :aGroup | 
		aGroup
			addItem: [ :anItem | 
				anItem
					name: 'Add a child query';
					icon: (self iconNamed: #smallAdd);
					help: 'Restrict result by adding a query';
					action: [ self addNewChildQueryAction ] ];
			addItem: [ :anItem | 
				anItem
					name: 'Remove this query';
					icon: (self iconNamed: #remove);
					help: 'Remove query and its sub-queries';
					action: [ self removeQueryAction ] ] ].

	optionsMenuButton := self newMenuButton
		                     menu: optionsMenuGroup;
		                     yourself
]

{ #category : #initialization }
MiNewQueryCreationPresenter >> initializeLayout [

	| tempLayout |
	tempLayout := SpBoxLayout newLeftToRight
		              spacing: 5;
		              borderWidth: 5;
		              yourself.
	self indentationSpacesPresenters do: [ :each | 
		tempLayout add: each expand: false ].
	tempLayout
		add: #queryNumberLabelPresenter expand: false;
		add: #queryTypesDropListPresenter width: 130;
		add: #queryConfigurationPresenter;
		addLast: #optionsMenuButton expand: false.
	self layout: tempLayout
]

{ #category : #initialization }
MiNewQueryCreationPresenter >> initializeNumberLabel [

	queryNumberLabelPresenter := self newLabel.
	queryNumberLabelPresenter label: queryNumber asString
]

{ #category : #initialization }
MiNewQueryCreationPresenter >> initializePresenters [

	self initializeLayout.
	self initializeButtons.
	self initializeNumberLabel.

	self initializeQueryTypesDropList.
	"After setting whenSelectedItemChangedDo:, select the fastest query while we do not compute the
	results in a fork.
	This is for instantiate queryConfigurationPresenter variable"
	queryTypesDropListPresenter selectItem: FQBooleanQuery
]

{ #category : #initialization }
MiNewQueryCreationPresenter >> initializeQueryTypesDropList [

	queryTypesDropListPresenter := self newDropList.
	queryTypesDropListPresenter
		items: parentPresenter availableQueryTypes;
		display: [ :queryClass | queryClass label ];
		whenSelectedItemChangedDo: [ :queryClass | 
			self updateQueryConfigurationFor: queryClass ]
]

{ #category : #accessing }
MiNewQueryCreationPresenter >> name [

	^ 'Q', queryNumber asString
]

{ #category : #actions }
MiNewQueryCreationPresenter >> newQueryForClass: queryClass [

	| newQuery |
	(parentQuery children includes: self query) ifTrue: [ 
		parentQuery removeChild: self query ].

	newQuery := queryClass isNAryQuery
		            ifTrue: [ 
		            queryClass subqueries: OrderedCollection empty ]
		            ifFalse: [ queryClass defaultForParent: parentQuery ].
	parentQuery addChild: newQuery.
	^ newQuery
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

{ #category : #'api - actions' }
MiNewQueryCreationPresenter >> queryChangedUpdate [

	parentPresenter ifNotNil: [ 
		parentPresenter queryChangedUpdate: self query ]
]

{ #category : #accessing }
MiNewQueryCreationPresenter >> queryNumber: anInteger [

	queryNumber := anInteger
]

{ #category : #'api - actions' }
MiNewQueryCreationPresenter >> queryPresentersListChanged [

	queryConfigurationPresenter queryPresentersListChanged
]

{ #category : #accessing }
MiNewQueryCreationPresenter >> queryTypesDropList [

	^ queryTypesDropListPresenter
]

{ #category : #actions }
MiNewQueryCreationPresenter >> removeQueryAction [

	parentPresenter removeQueryAction: self
]

{ #category : #'accessing - model' }
MiNewQueryCreationPresenter >> setModelBeforeInitialization: aQuery [

	parentQuery := aQuery
]

{ #category : #update }
MiNewQueryCreationPresenter >> updateQueryConfigurationFor: queryClass [

	| newQuery |
	"Create the new query"
	newQuery := self newQueryForClass: queryClass.

	"Instantiate the configuration presenter with the new created query"
	queryConfigurationPresenter := self instantiate:
		                               (queryClass miPresenterClass
			                                owner: self
			                                on: newQuery).

	self update
]
