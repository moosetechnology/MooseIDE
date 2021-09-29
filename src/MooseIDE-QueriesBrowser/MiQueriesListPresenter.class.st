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
		'parentQueryBrowser',
		'queryItemsPresenters'
	],
	#category : #'MooseIDE-QueriesBrowser-Main presenters'
}

{ #category : #'api - actions' }
MiQueriesListPresenter >> addNewChildQueryAction: query [

	| newPresenter indexToInsert |
	newPresenter := MiQueryListItemPresenter
		                on: query
		                owner: self
		                parentPresenter: self.
	newPresenter setQueryNumber: queryCounter.
	queryCounter := queryCounter + 1.
	indexToInsert := queryItemsPresenters findFirst: [ :each | 
		                 each query = query ].
	queryItemsPresenters add: newPresenter afterIndex: indexToInsert.

	parentQueryBrowser selectQuery: query.
	self updateComponentList
]

{ #category : #actions }
MiQueriesListPresenter >> addNewFirstLevelQuery [

	queryItemsPresenters add: self newFirstLevelQueryPresenter.
	self updateComponentList
]

{ #category : #accessing }
MiQueriesListPresenter >> availableQueryTypes [

	^ FQAbstractQuery allSubclasses select: [ :each | 
		  each isAvailableForQueriesSize: queryItemsPresenters size ]
]

{ #category : #accessing }
MiQueriesListPresenter >> creationPresenters [

	^ queryItemsPresenters
]

{ #category : #'api - actions' }
MiQueriesListPresenter >> disableProgressNotification [

	progressNotificationPresenter := SpNullPresenter new.
	spinnerMorph delete.
	self flag: 'Update is being used'.
	self update
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
		                                 morph:
			                                 (PanelMorph new addMorphFront:
					                                  morph);
		                                 yourself.
	parentQueryBrowser window ifNotNil: [ 
		queriesBrowserMorph := parentQueryBrowser window window.
		spinnerMorph position:
			queriesBrowserMorph extent / 2 + queriesBrowserMorph position.
		spinnerMorph openInWorld ].
	self flag: 'Update is being used'.
	self update
]

{ #category : #'api - actions' }
MiQueriesListPresenter >> followNewEntity [

	queryItemsPresenters
		collect: #queryConfigurationPresenter
		thenDo: [ :each | 
			each query resetResult.
			each query parent isRootQuery ifTrue: [ 
				each query parent: parentQueryBrowser rootQuery ] ]
]

{ #category : #initialization }
MiQueriesListPresenter >> initialize [

	queryCounter := 1.
	super initialize
]

{ #category : #initialization }
MiQueriesListPresenter >> initializeAddRootQueryButton [

	addRootQueryButton := self newButton.
	addRootQueryButton
		icon: (self iconNamed: #smallAdd);
		action: [ self addNewFirstLevelQuery ]
]

{ #category : #initialization }
MiQueriesListPresenter >> initializeComponentListPresenter [

	componentListPresenter := self newComponentList.
	componentListPresenter
		activateOnSingleClick;
		propagateNaturalHeight: true;
		whenSelectedDo: [ :selectedPresenter | 
			parentQueryBrowser selectQuery: selectedPresenter query ]
]

{ #category : #initialization }
MiQueriesListPresenter >> initializeLayout [

	self layout: (SpBoxLayout newTopToBottom
			 add: (SpBoxLayout newLeftToRight
					  add: #addRootQueryButton width: self class iconWidth;
					  yourself)
			 expand: false;
			 add: #componentListPresenter;
			 add: #progressNotificationPresenter expand: false;
			 yourself)
]

{ #category : #initialization }
MiQueriesListPresenter >> initializePresenters [

	self initializeLayout.
	queryItemsPresenters := OrderedCollection empty.
	self initializeAddRootQueryButton.
	self initializeComponentListPresenter.
	self initializeProgressPresenter
]

{ #category : #initialization }
MiQueriesListPresenter >> initializeProgressPresenter [

	progressNotificationPresenter := SpNullPresenter new.
	spinnerMorph := SpSpinnerMorph new
]

{ #category : #actions }
MiQueriesListPresenter >> newFirstLevelQueryPresenter [

	"This is a query that is a direct child of a FQRootQuery"

	| queryCreationPresenter |
	queryCreationPresenter := MiQueryListItemPresenter
		                          on: parentQueryBrowser rootQuery
		                          owner: self
		                          parentPresenter: self.
	queryCreationPresenter setQueryNumber: queryCounter.
	queryCounter := queryCounter + 1.
	^ queryCreationPresenter
]

{ #category : #'api - actions' }
MiQueriesListPresenter >> queryChangedUpdate: query [

	parentQueryBrowser selectQuery: query
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

	parentQueryBrowser removeQuery: aQueryCreationPresenter query.
	queryItemsPresenters remove: aQueryCreationPresenter.
	self removePresentersAssociatedWith: aQueryCreationPresenter query.
	self updateComponentList
]

{ #category : #'accessing - model' }
MiQueriesListPresenter >> setModelBeforeInitialization: aQueryBrowserPresenter [

	parentQueryBrowser := aQueryBrowserPresenter
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
