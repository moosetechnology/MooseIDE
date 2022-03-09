"
I am a MooseIDE browser that allows to create custom queries that applies to a MooseModel. I have a `Mi
queryBuilderPresenter` instance variable that contains a list with all the queries that you want to apply to the Moose model.
"
Class {
	#name : #MiQueriesBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'queryResultTreePresenter',
		'queryCodePresenter',
		'queryNotebookPresenter',
		'selectedQuery',
		'rootQuery',
		'queriesListPresenter'
	],
	#category : #'MooseIDE-QueriesBrowser-Main presenters'
}

{ #category : #'world menu' }
MiQueriesBrowser class >> menuCommandOn: aBuilder [

	<worldMenu>
	<miBrowsers>
	(aBuilder item: #QueriesBrowser)
		parent: #Moose;
		label: self title;
		icon: (self iconNamed: #mooseTree);
		order: 3;
		help: self helpMessage;
		action: [ self open ]
]

{ #category : #'instance creation' }
MiQueriesBrowser class >> newModel [

	^ FQRootQuery new
]

{ #category : #'instance creation' }
MiQueriesBrowser class >> open [

	"This method implementation is the same as their parent. But it is here for opening this browser more confortably from the system's browser."

	<script>
	^ super open
]

{ #category : #specs }
MiQueriesBrowser class >> title [

	^ 'Queries Browser'
]

{ #category : #accessing }
MiQueriesBrowser class >> titleForModelName: mooseModelName [

	^ self title , ' (' , mooseModelName , ')'
]

{ #category : #specs }
MiQueriesBrowser class >> windowSize [

	^ 650 @ 420
]

{ #category : #'window control' }
MiQueriesBrowser >> browserClosed [
	super browserClosed.
	application unregisterProducer: self
]

{ #category : #testing }
MiQueriesBrowser >> canFollowEntity: anObject [

	^ anObject isMooseObject and: [ 
		  (anObject asMooseGroup allUsing: FamixTNamedEntity) isNotEmpty ]
]

{ #category : #actions }
MiQueriesBrowser >> followEntity: anEntity [

	| busMooseEntities |
	"Create a group in case that only one entity was received from the bus"
	busMooseEntities := anEntity asMooseGroup allUsing: FamixTNamedEntity.
		
	"Create the new root query"
	self resetRootQueryForEntities: busMooseEntities.

	"Update window's title"
	self window
		title: (self class titleForModelName: busMooseEntities first mooseModel name).

	"Update the all the sub presenters with this new query"
	queriesListPresenter followNewEntity
]

{ #category : #initialization }
MiQueriesBrowser >> initialize [ 
	super initialize.
	application registerProducer: self for: FQAbstractQuery 
]

{ #category : #initialization }
MiQueriesBrowser >> initializeLayout [

	| tempLayout |
	tempLayout := SpBoxLayout newTopToBottom
		              spacing: 5;
		              yourself.
	tempLayout add: self class defaultLayout expand: false.
	tempLayout add: (SpPanedLayout new
			 add: queriesListPresenter;
			 add: queryNotebookPresenter;
			 yourself).
	self layout: tempLayout
]

{ #category : #initialization }
MiQueriesBrowser >> initializeNotebookPresenter [

	queryNotebookPresenter := self newNotebook.
	queryNotebookPresenter pages: { 
			(SpNotebookPage
				 title: 'Result of current query'
				 provider: [ queryResultTreePresenter ]).
			(SpNotebookPage
				 title: 'Current query code'
				 provider: [ queryCodePresenter ]) }
]

{ #category : #initialization }
MiQueriesBrowser >> initializePresenters [

	self initializeQueryCodePresenter.
	self initializeResultTreePresenter.
	self initializeNotebookPresenter.
	self initializeQueryBuilder.
	self initializeLayout
]

{ #category : #initialization }
MiQueriesBrowser >> initializeQueryBuilder [

	queriesListPresenter := self
		                        instantiate: MiQueriesListPresenter
		                        on: self
]

{ #category : #initialization }
MiQueriesBrowser >> initializeQueryCodePresenter [

	queryCodePresenter := self instantiate: QueryCodePresenter
]

{ #category : #initialization }
MiQueriesBrowser >> initializeResultTreePresenter [

	queryResultTreePresenter := self instantiate: QueryResultTreePresenter.
	queryResultTreePresenter updateForEntities: self queryResultEntities
]

{ #category : #brokerage }
MiQueriesBrowser >> itemsFor: aClass [
	^rootQuery children select: [ :query | query isKindOf: aClass ]
]

{ #category : #accessing }
MiQueriesBrowser >> miSelectedItem [

	| selected |
	selected := queryResultTreePresenter miSelectedItem
		            ifEmpty: [ selectedQuery result ]
		            ifNotEmpty: [ queryResultTreePresenter miSelectedItem ].
	selected := selected specialize.
	^ selected size = 1
		  ifTrue: [ selected anyOne ]
		  ifFalse: [ selected ]
]

{ #category : #accessing }
MiQueriesBrowser >> queryResultEntities [

	^ selectedQuery result
]

{ #category : #removing }
MiQueriesBrowser >> removeChild: childToRemove fromParent: aParent [

	(aParent children includes: childToRemove) ifTrue: [ 
		aParent removeChild: childToRemove.
		^ self ].
	aParent children do: [ :aChild | 
		self removeChild: childToRemove fromParent: aChild ]
]

{ #category : #'api - actions' }
MiQueriesBrowser >> removeQuery: aQuery [

	self removeChild: aQuery fromParent: rootQuery.
	application removeItem: aQuery
]

{ #category : #'api - actions' }
MiQueriesBrowser >> resetRootQueryForEntities: busMooseEntities [

	rootQuery
		resetResult;
		result: busMooseEntities;
		name: busMooseEntities first mooseModel name.
	self selectQuery: rootQuery
]

{ #category : #accessing }
MiQueriesBrowser >> rootQuery [
	^ rootQuery
]

{ #category : #actions }
MiQueriesBrowser >> selectQuery: aQuery [

	selectedQuery := aQuery.
	queryResultTreePresenter updateForQuery: aQuery.
	queryCodePresenter updateForQuery: aQuery
]

{ #category : #accessing }
MiQueriesBrowser >> selectedQuery [

	^ selectedQuery
]

{ #category : #'accessing - model' }
MiQueriesBrowser >> setModelBeforeInitialization: aRootQuery [

	rootQuery := aRootQuery.
	selectedQuery := aRootQuery
]
