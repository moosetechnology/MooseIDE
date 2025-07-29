"
I am a MooseIDE browser that allows to create custom queries that applies to a MooseModel. I have a `Mi
queryBuilderPresenter` instance variable that contains a list with all the queries that you want to apply to the Moose model.

Accepted entities: a MooseGroup with some named entities.
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

{ #category : #keymaps }
MiQueriesBrowser class >> browserKey [

	^ $f
]

{ #category : #'world menu' }
MiQueriesBrowser class >> menuCommandOn: aBuilder [

	<worldMenu>
	<miBrowsersMenu>
	^ self buildMenuItemIn: aBuilder
]

{ #category : #'world menu' }
MiQueriesBrowser class >> menuIconName [

	^ #mooseTree
]

{ #category : #'world menu' }
MiQueriesBrowser class >> menuItem [

	^ #QueriesBrowser
]

{ #category : #'world menu' }
MiQueriesBrowser class >> menuPriority [

	^ self menuMainToolsPriority + 3
]

{ #category : #'instance creation' }
MiQueriesBrowser class >> newModel [

	^ MiQueriesModel newModel
]

{ #category : #'instance creation' }
MiQueriesBrowser class >> open [

	"This method implementation is the same as their parent. But it is here for opening this browser more confortably from the system's browser."

	<script>
	^ super open
]

{ #category : #specs }
MiQueriesBrowser class >> preferredExtent [

	^ 650 @ 420
]

{ #category : #specs }
MiQueriesBrowser class >> title [

	^ 'Queries Browser'
]

{ #category : #'window control' }
MiQueriesBrowser >> browserClosed [
	super browserClosed.
	application unregisterProducer: self
]

{ #category : #testing }
MiQueriesBrowser >> canFollowEntity: anObject [

	^ anObject isMooseObject and: [ 
		  (anObject asMooseGroup select: #isQueryable ) isNotEmpty ]
]

{ #category : #testing }
MiQueriesBrowser >> canTagEntities [ 
	self flag: 'TODO, put browser in default Browser/Model pattern (issue #809) so that tagging can work'.
	^false
]

{ #category : #actions }
MiQueriesBrowser >> clearQueries [

	| anyQuery |

	self rootQuery children ifEmpty: [ ^ self ].

	anyQuery := self rootQuery children anyOne.
	self rootQuery children removeAll.
	self application removeItem: anyQuery.
	self selectQuery: rootQuery
]

{ #category : #'api - actions' }
MiQueriesBrowser >> enableProgressNotification [

	queryResultTreePresenter := self instantiate: MiSpinnerPresenter.
	queryNotebookPresenter resetAllPageContents
]

{ #category : #actions }
MiQueriesBrowser >> followEntity: anEntity [

	| busMooseEntities |
	super followEntity: anEntity.
	"Create a group in case that only one entity was received from the bus"
	busMooseEntities := anEntity asMooseGroup .

	"Create the new root query"
	self resetRootQueryForEntities: busMooseEntities.



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

	self layout: (SpPanedLayout new
			 add: queriesListPresenter;
			 add: queryNotebookPresenter;
			 yourself)
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

	queryResultTreePresenter := self newMooseGroupsTreeTable.

	queryResultTreePresenter updateForEntities: self queryResultEntities
]

{ #category : #brokerage }
MiQueriesBrowser >> itemsFor: aClass [
	
	^ rootQuery allChildren select: [ :query | query isKindOf: aClass ]
]

{ #category : #accessing }
MiQueriesBrowser >> miSelectedItem [

	^ queryResultTreePresenter miSelectedItem asCollection
		  ifEmpty: [ selectedQuery result ]
		  ifNotEmpty: [ :items | items ]
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
		input: busMooseEntities;
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
	self updateResultPresenterForQuery: aQuery.
	queryCodePresenter updateForQuery: aQuery
]

{ #category : #accessing }
MiQueriesBrowser >> selectedQuery [

	^ selectedQuery
]

{ #category : #initialization }
MiQueriesBrowser >> setModelBeforeInitialization: aRootQuery [
	self flag: 'Does not follow default Model/Browser organization'.
	rootQuery := aRootQuery.
	selectedQuery := aRootQuery
]

{ #category : #actions }
MiQueriesBrowser >> showResultOfQuery: aQuery [

	| result |
	self enableProgressNotification.

	result := aQuery result.

	self initializeResultTreePresenter.
	"This will sho the correct queryResultTreePresenter:"
	queryNotebookPresenter resetAllPageContents
]

{ #category : #actions }
MiQueriesBrowser >> updateResultPresenterForQuery: aQuery [

	aQuery isValid
		ifTrue: [ self showResultOfQuery: aQuery ]
		ifFalse: [ 
		queryResultTreePresenter updateForEntities: MooseGroup new ]
]
