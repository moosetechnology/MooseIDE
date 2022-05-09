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

{ #category : #initialization }
MiQueriesBrowserToolbar >> initializeButtons [

	addRootQueryButton := self newButton.
	addRootQueryButton
		icon: (self iconNamed: #smallAdd);
		action: [ queryListPresenter addNewFirstLevelQuery ].

	saveQueriesButton := (MiSaveQueriesCommand forSpecContext:
		                      queryListPresenter) asButtonPresenter.

	loadQueriesButton := self newButton.
	loadQueriesButton
		icon: (self iconNamed: #smallLoadProject);
		action: [ 
			(MiLoadQueriesPresenter on: queryListPresenter) openDialog ];
		help: 'Load a set of queries into the browser'.

	clearQueriesButton := self newButton.
	clearQueriesButton
		icon: (self iconNamed: #smallUpdate);
		action: [ queryListPresenter reinitializeQueryPresenters ];
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
MiQueriesBrowserToolbar >> initializePresenters [

	self initializeButtons.
	self initializeLayout
]

{ #category : #'accessing - model' }
MiQueriesBrowserToolbar >> setModelBeforeInitialization: aQueryListPresenter [

	queryListPresenter := aQueryListPresenter
]
