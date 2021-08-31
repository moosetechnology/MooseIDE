"
I contain a presenter collection. Each of the elements of that collection is a query creation presenter. When the add button is pressed, a presenter is added to the collection. Same for the remove button.
Also I have a componentListPresenter instance variable. The elements of this list are the same as the elements of the presenters collection.
Each query is an instance of `MiNewQueryCreationPresenter`.

I manage all the logic related to showing all the queries. Also, I update myself and my parentBrowser when a query is added or removed.
"
Class {
	#name : #MiQueryBuilderPresenter,
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
MiQueryBuilderPresenter >> addNewChildQueryAction: query [

	| newPresenter indexToInsert |
	newPresenter := self instantiate: (MiNewQueryCreationPresenter
			                 on: query
			                 parentPresenter: self
			                 queryNumber: queryCounter).
	indexToInsert := presenters findFirst: [ :each | each query = query ].
	presenters add: newPresenter afterIndex: indexToInsert.
	queryCounter := queryCounter + 1.

	parentBrowser selectQuery: query.
	self updateComponentList
]

{ #category : #actions }
MiQueryBuilderPresenter >> addNewFirstLevelQuery [

	presenters add: self newFirstLevelQueryPresenter.
	self updateComponentList
]

{ #category : #accessing }
MiQueryBuilderPresenter >> availableQueryTypes [

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
MiQueryBuilderPresenter >> creationPresenters [

	^ presenters
]

{ #category : #'api - actions' }
MiQueryBuilderPresenter >> disableProgressNotification [

	progressNotificationPresenter := SpNullPresenter new.
	spinnerMorph delete.
	self update
]

{ #category : #'api - actions' }
MiQueryBuilderPresenter >> enableProgressNotification [

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
MiQueryBuilderPresenter >> followAction [

	"When a new entity arrives on the bus we reset the presenter to have only one query again. Like if it were openen again."

	queryCounter := 1.
	presenters := OrderedCollection empty.
	self updateComponentList
]

{ #category : #initialization }
MiQueryBuilderPresenter >> initialize [

	queryCounter := 1.
	super initialize
]

{ #category : #initialization }
MiQueryBuilderPresenter >> initializeAddRootQueryButton [

	addRootQueryButton := self newButton.
	addRootQueryButton
		icon: (self iconNamed: #smallAdd);
		action: [ self addNewFirstLevelQuery ]
]

{ #category : #initialization }
MiQueryBuilderPresenter >> initializeComponentListPresenter [

	componentListPresenter := self newComponentList.
	componentListPresenter
		activateOnSingleClick;
		propagateNaturalHeight: true;
		whenSelectedDo: [ :selectedPresenter | 
			parentBrowser selectQuery: selectedPresenter query ]
]

{ #category : #initialization }
MiQueryBuilderPresenter >> initializeLayout [

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
MiQueryBuilderPresenter >> initializePresenters [

	self initializeLayout.
	presenters := OrderedCollection empty.
	self initializeAddRootQueryButton.
	self initializeComponentListPresenter.
	self initializeProgressPresenter
]

{ #category : #initialization }
MiQueryBuilderPresenter >> initializeProgressPresenter [

	progressNotificationPresenter := SpNullPresenter new.
	spinnerMorph := SpSpinnerMorph new
]

{ #category : #actions }
MiQueryBuilderPresenter >> newFirstLevelQueryPresenter [

	"This is a query that is a direct child of a FQRootQuery"

	| queryCreationPresenter |
	queryCreationPresenter := self instantiate:
		                          (MiNewQueryCreationPresenter
			                           on: parentBrowser rootQuery
			                           parentPresenter: self
			                           queryNumber: queryCounter).
	queryCounter := queryCounter + 1.
	^ queryCreationPresenter
]

{ #category : #'api - actions' }
MiQueryBuilderPresenter >> queryChangedUpdate: query [

	parentBrowser queryChangedUpdate: query
]

{ #category : #actions }
MiQueryBuilderPresenter >> removePresentersAssociatedWith: nodeQuery [

	nodeQuery children do: [ :childQuery | 
		| presenterToRemove |
		presenterToRemove := presenters detect: [ :aPresenter | 
			                     aPresenter query = childQuery ].
		presenters remove: presenterToRemove.
		self removePresentersAssociatedWith: childQuery ]
]

{ #category : #'api - actions' }
MiQueryBuilderPresenter >> removeQueryAction: aQueryCreationPresenter [

	parentBrowser removeQuery: aQueryCreationPresenter query.
	presenters remove: aQueryCreationPresenter.
	self removePresentersAssociatedWith: aQueryCreationPresenter query.
	self updateComponentList
]

{ #category : #'accessing - model' }
MiQueryBuilderPresenter >> setModelBeforeInitialization: aQueryBrowserPresenter [

	parentBrowser := aQueryBrowserPresenter
]

{ #category : #update }
MiQueryBuilderPresenter >> updateComponentList [

	self updateSubqueriesListPresenter.
	componentListPresenter presenters: presenters
]

{ #category : #update }
MiQueryBuilderPresenter >> updateSubqueriesListPresenter [

	presenters do: [ :queryCreationPresenter | 
		queryCreationPresenter queryPresentersListChanged ]
]