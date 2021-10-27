"
I contain a presenter collection. Each of the elements of that collection is a query creation presenter. When the add button is pressed, a presenter is added to the collection. Same for the remove button.
Also I have a componentListPresenter instance variable. The elements of this list are the same as the elements of the presenters collection.
Each query is an instance of `MiNewQueryCreationPresenter`.

I manage all the logic related to showing all the queries. Also, I update myself and my parentBrowser when a query is added or removed.
"
Class {
	#name : #MiQueriesListPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'componentListPresenter',
		'queryCounter',
		'addRootQueryButton',
		'progressNotificationPresenter',
		'spinnerMorph',
		'queryItemsPresenters',
		'saveQueriesButton',
		'loadQueriesButton',
		'loadQueriesList',
		'clearQueriesButton',
		'addManualQueryButton',
		'queriesBrowser'
	],
	#category : #'MooseIDE-QueriesBrowser-Main presenters'
}

{ #category : #'api - actions' }
MiQueriesListPresenter >> addNewChildQueryAction: query [

	| newPresenter indexToInsert |
	newPresenter := self createNewQueryPresenter: query.
	indexToInsert := queryItemsPresenters findFirst: [ :each | 
		                 each query = query ].
	queryItemsPresenters add: newPresenter afterIndex: indexToInsert.
	queriesBrowser selectQuery: query.
	self updateComponentList
]

{ #category : #actions }
MiQueriesListPresenter >> addNewFirstLevelQuery [

	queryItemsPresenters add: self newFirstLevelQueryPresenter.
	self updateComponentList
]

{ #category : #actions }
MiQueriesListPresenter >> addNewManualQuery [
	
	| newPresenter |
	newPresenter := MiQueryListItemPresenter
		newManualQueryOn: queriesBrowser rootQuery
		owner: self
		queriesListPresenter: self.
	newPresenter setQueryNumber: queryCounter.
	queryCounter := queryCounter + 1.

	queryItemsPresenters add: newPresenter.
	self updateComponentList
]

{ #category : #accessing }
MiQueriesListPresenter >> availableQueryTypes [

	^ FQAbstractQuery allSubclasses select: [ :each | 
		  each isAvailableForQueriesSize: queryItemsPresenters size ]
]

{ #category : #actions }
MiQueriesListPresenter >> constructQueriesWithFile: aFile [

	| newQueries |
	
	[ self enableProgressNotification ] asJob run.
	
	aFile readStreamDo: [ :stream | 
		newQueries := STON fromStream: stream ].

	"Put the root query as the parent for the first level unary queries"
	newQueries do: [ :each | 
		each parent ifNil: [ 
			each parent: queriesBrowser rootQuery ] ].

	"We cannot use a collect here because we need to keep track of how many queries we are creating
	iteration by iteration"
	newQueries do: [ :each | 
		| newPresenter|
		newPresenter := each parent
			ifNil: [ self createNewQueryPresenter: queriesBrowser rootQuery ]
			ifNotNil: [ self createNewQueryPresenter: each parent ].
		newPresenter configureFor: each.
		queryItemsPresenters add: newPresenter ].

	self updateComponentList.
	
	self disableProgressNotification
]

{ #category : #'api - actions' }
MiQueriesListPresenter >> createNewQueryPresenter: query [

	| newPresenter |
	newPresenter := MiQueryListItemPresenter
		                on: query
		                owner: self
		                queriesListPresenter: self.
	newPresenter setQueryNumber: queryCounter.
	queryCounter := queryCounter + 1.
	^ newPresenter
]

{ #category : #'api - actions' }
MiQueriesListPresenter >> disableProgressNotification [

	progressNotificationPresenter := SpNullPresenter new.
	spinnerMorph delete.
	self initializeLayout
]

{ #category : #'api - actions' }
MiQueriesListPresenter >> enableProgressNotification [

	| queriesBrowserMorph font morph |
	font := LogicalFont
			familyName: StandardFonts defaultFont familyName
			pointSize: 12.
	morph := StringMorph
			contents: 'Computing...'
			font: font
			emphasis: TextEmphasis italic.
	progressNotificationPresenter := SpMorphPresenter new
			morph: (PanelMorph new
				addMorphFront: morph;
				yourself);
			yourself.
	queriesBrowser window ifNotNil: [ 
		queriesBrowserMorph := queriesBrowser window window.
		spinnerMorph position:
			queriesBrowserMorph extent / 2 + queriesBrowserMorph position.
		spinnerMorph openInWorld ].
	self initializeLayout
]

{ #category : #accessing }
MiQueriesListPresenter >> famixQueries [

	^ (queryItemsPresenters collect: #queryConfiguratorPresenter) 
		  collect: #query
]

{ #category : #'api - actions' }
MiQueriesListPresenter >> findPresenterForQuery: aQuery [

	^ queryItemsPresenters detect: [ :each | each query = aQuery ]
]

{ #category : #'api - actions' }
MiQueriesListPresenter >> followNewEntity [

	queryItemsPresenters
		collect: #queryConfiguratorPresenter
		thenDo: [ :each | 
			each query resetResult.
			(each query parent isNotNil and: [ each query parent isRootQuery ]) 
				ifTrue: [ each query parent: queriesBrowser rootQuery ] ]
]

{ #category : #initialization }
MiQueriesListPresenter >> initialize [

	queryCounter := 1.
	super initialize
]

{ #category : #initialization }
MiQueriesListPresenter >> initializeButtons [

	| saveCommand |
	addRootQueryButton := self newButton.
	addRootQueryButton
		icon: (self iconNamed: #smallAdd);
		action: [ self addNewFirstLevelQuery ].

	saveCommand := MiSaveQueriesCommand new.
	saveCommand context: self.
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
		action: [ self reinitializeQueryPresenters  ];
		label: 'Clear queries'.

	addManualQueryButton := self newButton.
	addManualQueryButton
		icon: (self iconNamed: #edit);
		label: 'Manual Query';
		action: [ self addNewManualQuery ]
]

{ #category : #initialization }
MiQueriesListPresenter >> initializeComponentListPresenter [

	componentListPresenter := self newComponentList.
	componentListPresenter
		activateOnSingleClick;
		propagateNaturalHeight: true;
		whenSelectedDo: [ :selectedPresenter | 
			queriesBrowser selectQuery: selectedPresenter query ]
]

{ #category : #initialization }
MiQueriesListPresenter >> initializeLayout [

	self layout: (SpBoxLayout newTopToBottom
		add: (SpBoxLayout newLeftToRight
			spacing: 5;
			add: addRootQueryButton width: self class iconWidth;
			add: addManualQueryButton expand: false;
			add: clearQueriesButton expand: false;
			addLast: loadQueriesButton withConstraints: [ :c | c width: self class iconWidth ];
			addLast: saveQueriesButton withConstraints: [ :c | c width: self class iconWidth ];
			yourself)
		expand: false;
		add: componentListPresenter;
		add: progressNotificationPresenter expand: false;
		yourself)
]

{ #category : #initialization }
MiQueriesListPresenter >> initializeLoadQueries [

	loadQueriesList := self instantiate: LoadQueriesPresenter.
	loadQueriesList okAction: [ 
		self constructQueriesWithFile: loadQueriesList selectedFile ]
]

{ #category : #initialization }
MiQueriesListPresenter >> initializePresenters [

	queryItemsPresenters := OrderedCollection empty.
	self initializeButtons.
	self initializeComponentListPresenter.
	self initializeProgressPresenter.
	self initializeLoadQueries.
	self initializeLayout
]

{ #category : #initialization }
MiQueriesListPresenter >> initializeProgressPresenter [

	progressNotificationPresenter := SpNullPresenter new.
	spinnerMorph := SpSpinnerMorph new
]

{ #category : #testing }
MiQueriesListPresenter >> isQueryUsed: aQuery [

	^ (queryItemsPresenters collect: #queryConfiguratorPresenter)
			anySatisfy: [ :queryPresenter | 
				queryPresenter isQueryUsed: aQuery ]
]

{ #category : #actions }
MiQueriesListPresenter >> newFirstLevelQueryPresenter [

	"This is a query that is a direct child of a FQRootQuery"

	^ self createNewQueryPresenter: queriesBrowser rootQuery
]

{ #category : #accessing }
MiQueriesListPresenter >> queriesBrowser [

	^ queriesBrowser
]

{ #category : #'api - actions' }
MiQueriesListPresenter >> queryChangedUpdate: query [

	queriesBrowser selectQuery: query
]

{ #category : #accessing }
MiQueriesListPresenter >> queryItemsPresenters [

	^ queryItemsPresenters
]

{ #category : #actions }
MiQueriesListPresenter >> reinitializeQueryPresenters [

	queryCounter := 1.
	queryItemsPresenters := OrderedCollection new.
	self updateComponentList
]

{ #category : #actions }
MiQueriesListPresenter >> removePresentersAssociatedWith: nodeQuery [

	nodeQuery children do: [ :childQuery | 
		| presenterToRemove |
		presenterToRemove := queryItemsPresenters detect: [ :aPresenter | 
			                     aPresenter query = childQuery ].
		queryItemsPresenters remove: presenterToRemove.
		self removePresentersAssociatedWith: childQuery ]
]

{ #category : #'api - actions' }
MiQueriesListPresenter >> removeQueryAction: aQueryCreationPresenter [

	queriesBrowser removeQuery: aQueryCreationPresenter query.
	queryItemsPresenters remove: aQueryCreationPresenter.
	self removePresentersAssociatedWith: aQueryCreationPresenter query.
	self updateComponentList
]

{ #category : #'accessing - model' }
MiQueriesListPresenter >> setModelBeforeInitialization: aQueryBrowserPresenter [

	queriesBrowser := aQueryBrowserPresenter
]

{ #category : #actions }
MiQueriesListPresenter >> showLoadQueriesPopover [

	loadQueriesList resetItems.
	self newPopover
		relativeTo: loadQueriesButton;
		presenter: loadQueriesList;
		bePositionLeft;
		popup
]

{ #category : #update }
MiQueriesListPresenter >> updateComponentList [

	self updateSubqueriesListPresenter.
	componentListPresenter presenters: queryItemsPresenters
]

{ #category : #update }
MiQueriesListPresenter >> updateSubqueriesListPresenter [

	"Maybe we should change this to use announcements"

	queryItemsPresenters do: [ :queryCreationPresenter | 
		queryCreationPresenter queryPresentersListChanged ]
]
