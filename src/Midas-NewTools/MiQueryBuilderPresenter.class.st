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
		'addRootQueryButton'
	],
	#category : #'Midas-NewTools-Queries Browser'
}

{ #category : #'api - actions' }
MiQueryBuilderPresenter >> addNewQueryAction: query [

	| newPresenter |
	newPresenter := self instantiate: (MiNewQueryCreationPresenter
			                 on: query
			                 parentPresenter: self
			                 queryNumber: queryCounter).
	presenters add: newPresenter.
	queryCounter := queryCounter + 1.

	parentBrowser selectQuery: query.
	self updateComponentList
]

{ #category : #actions }
MiQueryBuilderPresenter >> addNewRootQuery [

	presenters add: self newRootQueryPresenter.
	self updateComponentList
]

{ #category : #accessing }
MiQueryBuilderPresenter >> availableQueryTypes [

	| queryTypes |
	queryTypes := FQUnaryQuery allSubclasses select: #canBeConfigured.
	"There must be at least one query to do the negation operation"
	presenters ifNotEmpty: [ 
		queryTypes := queryTypes , FQComplementQuery asOrderedCollection ].
	"There must be at least two queries to create an n-ary query."
	presenters size > 1 ifTrue: [ 
		queryTypes := queryTypes , FQNaryQuery subclasses ].
	^ queryTypes
]

{ #category : #actions }
MiQueryBuilderPresenter >> createFirstQueryForComponentList [

	| queryCreationPresenter |
	queryCreationPresenter := self newRootQueryPresenter.
	presenters := OrderedCollection with: queryCreationPresenter.
	self updateComponentList
]

{ #category : #accessing }
MiQueryBuilderPresenter >> creationPresenters [

	^ presenters
]

{ #category : #'api - actions' }
MiQueryBuilderPresenter >> followAction [

	"When a new entity arrives on the bus we reset the presenter to have only one query again. Like if it were openen again."

	queryCounter := 1.
	self createFirstQueryForComponentList
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
		action: [ self addNewRootQuery ]
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
			 yourself)
]

{ #category : #initialization }
MiQueryBuilderPresenter >> initializePresenters [

	self initializeLayout.
	presenters := OrderedCollection empty.
	self initializeAddRootQueryButton.
	self initializeComponentListPresenter.
	self createFirstQueryForComponentList
]

{ #category : #actions }
MiQueryBuilderPresenter >> newRootQueryPresenter [

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
	"presenters last enable."
	self updateComponentList
]

{ #category : #'accessing model' }
MiQueryBuilderPresenter >> setModelBeforeInitialization: aQueryBrowserPresenter [

	parentBrowser := aQueryBrowserPresenter
]

{ #category : #update }
MiQueryBuilderPresenter >> updateComponentList [

	componentListPresenter presenters: presenters
]
