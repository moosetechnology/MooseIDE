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
		'presenters',
		'parentBrowser',
		'componentListPresenter',
		'queryCounter',
		'addRootQueryButton',
		'progressNotificationPresenter',
		'spinnerMorph'
	],
	#category : #'MooseIDE-QueriesBrowser-Main presenters'
}

{ #category : #'api - actions' }
MiQueriesListPresenter >> addNewChildQueryAction: query [

	| newPresenter indexToInsert |
	newPresenter := MiQueryListItemPresenter
		                owner: self
		                on: query
		                parentPresenter: self.
	newPresenter setQueryNumber: queryCounter.
	queryCounter := queryCounter + 1.
	indexToInsert := presenters findFirst: [ :each | each query = query ].
	presenters add: newPresenter afterIndex: indexToInsert.

	parentBrowser selectQuery: query.
	self updateComponentList
]

{ #category : #actions }
MiQueriesListPresenter >> addNewFirstLevelQuery [

	presenters add: self newFirstLevelQueryPresenter.
	self updateComponentList
]

{ #category : #accessing }
MiQueriesListPresenter >> availableQueryTypes [

	| queryTypes |
	queryTypes := FQUnaryQuery allSubclasses select: #canBeConfigured.
	"There must be at least one query to do the negation operation and the result size query"
	presenters ifNotEmpty: [ 
		queryTypes := queryTypes , FQComplementQuery asOrderedCollection
		              , FQResultSizeQuery asOrderedCollection ].
	"There must be at least two queries to create an n-ary query."
	presenters size > 1 ifTrue: [ 
		queryTypes := queryTypes , FQNAryQuery subclasses ].
	^ queryTypes
]

{ #category : #accessing }
MiQueriesListPresenter >> creationPresenters [

	^ presenters
]

{ #category : #'api - actions' }
MiQueriesListPresenter >> disableProgressNotification [

	progressNotificationPresenter := SpNullPresenter new.
	spinnerMorph delete.
	self update
]

{ #category : #'api - actions' }
MiQueriesListPresenter >> enableProgressNotification [

	| queriesBrowserMorph font morph |
	"progressNotificationPresenter := SpLabelPresenter new
		                                 label: 'Computing...';
		                                 yourself."
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
	"Only put the spinner if the queries browser is opened. Actually, there are no uses cases when this method is called without the queries browser being opened. This is only for avoid the tests faling. Because the tests use this method without open the queries browser."
	parentBrowser window ifNotNil: [ "Put the spinner in the middle of the queries browser"
		queriesBrowserMorph := parentBrowser window window.
		spinnerMorph position:
			queriesBrowserMorph extent / 2 + queriesBrowserMorph position.
		spinnerMorph openInWorld ].
	self update
]

{ #category : #'api - actions' }
MiQueriesListPresenter >> followAction [

	"When a new entity arrives on the bus we reset the presenter to have only one query again. Like if it were openen again."

	queryCounter := 1.
	presenters := OrderedCollection empty.
	self updateComponentList
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
			parentBrowser selectQuery: selectedPresenter query ]
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
	presenters := OrderedCollection empty.
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
		                          owner: self
		                          on: parentBrowser rootQuery
		                          parentPresenter: self.
	queryCreationPresenter setQueryNumber: queryCounter.
	queryCounter := queryCounter + 1.
	^ queryCreationPresenter
]

{ #category : #'api - actions' }
MiQueriesListPresenter >> queryChangedUpdate: query [

	parentBrowser selectQuery: query
]

{ #category : #actions }
MiQueriesListPresenter >> removePresentersAssociatedWith: nodeQuery [

	nodeQuery children do: [ :childQuery | 
		| presenterToRemove |
		presenterToRemove := presenters detect: [ :aPresenter | 
			                     aPresenter query = childQuery ].
		presenters remove: presenterToRemove.
		self removePresentersAssociatedWith: childQuery ]
]

{ #category : #'api - actions' }
MiQueriesListPresenter >> removeQueryAction: aQueryCreationPresenter [

	parentBrowser removeQuery: aQueryCreationPresenter query.
	presenters remove: aQueryCreationPresenter.
	self removePresentersAssociatedWith: aQueryCreationPresenter query.
	self updateComponentList
]

{ #category : #'accessing - model' }
MiQueriesListPresenter >> setModelBeforeInitialization: aQueryBrowserPresenter [

	parentBrowser := aQueryBrowserPresenter
]

{ #category : #update }
MiQueriesListPresenter >> updateComponentList [

	self updateSubqueriesListPresenter.
	componentListPresenter presenters: presenters
]

{ #category : #update }
MiQueriesListPresenter >> updateSubqueriesListPresenter [

	presenters do: [ :queryCreationPresenter | 
		queryCreationPresenter queryPresentersListChanged ]
]
