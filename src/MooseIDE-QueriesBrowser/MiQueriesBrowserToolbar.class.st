"
I am the toolbar for the queries browser that containts the buttons for adding a new first level query, clearing the queries, saving and loading
"
Class {
	#name : #MiQueriesBrowserToolbar,
	#superclass : #MiPresenter,
	#instVars : [
		'addRootQueryButton',
		'saveQueriesButton',
		'loadQueriesButton',
		'clearQueriesButton',
		'addManualQueryButton',
		'queryListPresenter',
		'loadQueriesList'
	],
	#category : #'MooseIDE-QueriesBrowser-Main presenters'
}

{ #category : #actions }
MiQueriesBrowserToolbar >> constructQueriesWithFile: aFile [

	| newQueries |
	aFile readStreamDo: [ :stream | 
		newQueries := STON fromStream: stream ].

	"Put the root query as the parent for the first level unary queries"
	newQueries do: [ :each | 
		each parent ifNil: [ "This works only for subclasses of FQUnaryQuery: " 
			each parent: queryListPresenter queriesBrowser rootQuery ] ].

	newQueries do: [ :each | 
		| newPresenter |
		newPresenter := queryListPresenter createNewQueryPresenter:
			                (each parent
				                 ifNil: [ 
				                 queryListPresenter queriesBrowser rootQuery ]
				                 ifNotNil: [ each parent ]).
		newPresenter configureFor: each.
		queryListPresenter queryItemsPresenters add: newPresenter ].

	queryListPresenter updateComponentList
]

{ #category : #initialization }
MiQueriesBrowserToolbar >> initializeButtons [

	| saveCommand |
	addRootQueryButton := self newButton.
	addRootQueryButton
		icon: (self iconNamed: #smallAdd);
		action: [ queryListPresenter addNewFirstLevelQuery ].

	saveCommand := MiSaveQueriesCommand new.
	saveCommand context: queryListPresenter.
	saveQueriesButton := saveCommand asSpecCommand asButtonPresenter.
	saveQueriesButton
		label: '';
		icon: (self iconNamed: MiSaveQueriesCommand iconName).

	loadQueriesButton := self newButton.
	loadQueriesButton
		icon: (self iconNamed: #smallLoadProject);
		action: [ self showLoadQueriesPopover ];
		help: 'Load a set of queries into the browser'.

	clearQueriesButton := self newButton.
	clearQueriesButton
		icon: (self iconNamed: #smallUpdate);
		action: [ queryListPresenter reinitializeQueryPresenters  ];
		label: 'Clear queries'.

	addManualQueryButton := self newButton.
	addManualQueryButton
		icon: (self iconNamed: #edit);
		label: 'Manual Query';
		action: [ queryListPresenter addNewManualQuery ]
]

{ #category : #initialization }
MiQueriesBrowserToolbar >> initializeLayout [

	self layout: (SpBoxLayout newLeftToRight
		spacing: 5;
		add: addRootQueryButton width: self class iconWidth;
		add: addManualQueryButton expand: false;
		add: clearQueriesButton expand: false;
		addLast: loadQueriesButton withConstraints: [ :c | c width: self class iconWidth ];
		addLast: saveQueriesButton withConstraints: [ :c | c width: self class iconWidth ];
		yourself)
]

{ #category : #initialization }
MiQueriesBrowserToolbar >> initializeLoadQueries [

	loadQueriesList := self instantiate: LoadQueriesPresenter.
	loadQueriesList okAction: [ 
		loadQueriesList owner dismiss.
		self constructQueriesWithFile: loadQueriesList selectedFile ]
]

{ #category : #initialization }
MiQueriesBrowserToolbar >> initializePresenters [

	self initializeButtons.
	self initializeLoadQueries.
	self initializeLayout
]

{ #category : #'accessing - model' }
MiQueriesBrowserToolbar >> setModelBeforeInitialization: aQueryListPresenter [

	queryListPresenter := aQueryListPresenter
]

{ #category : #actions }
MiQueriesBrowserToolbar >> showLoadQueriesPopover [

	loadQueriesList resetItems.
	self newPopover
		relativeTo: loadQueriesButton;
		presenter: loadQueriesList;
		bePositionLeft;
		popup
]
