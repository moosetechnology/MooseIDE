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

	^ MiQueriesModel new
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

	^ anObject isMooseObject and: [ anObject asMooseGroup anySatisfy: #isQueryable ]
]

{ #category : #testing }
MiQueriesBrowser >> canTagEntities [ 
	self flag: 'TODO, put browser in default Browser/Model pattern (issue #809) so that tagging can work'.
	^false
]

{ #category : #actions }
MiQueriesBrowser >> clearQueries [

	specModel clearQueries.
	self updateSelectedQuery
]

{ #category : #'api - actions' }
MiQueriesBrowser >> enableProgressNotification [

	queryResultTreePresenter := self instantiate: MiSpinnerPresenter.
	queryNotebookPresenter resetAllPageContents
]

{ #category : #actions }
MiQueriesBrowser >> followEntity: anEntity [

	| busMooseEntities allEntities |
	super followEntity: anEntity.
	"Create a group in case that only one entity was received from the bus"
	allEntities := anEntity asMooseGroup.
	busMooseEntities := allEntities select: #isQueryable.

	busMooseEntities size < allEntities size ifTrue: [
			self inform: (String streamContents: [ :s |
						 s
							 << 'Queries browser:';
							 cr;
							 << (allEntities size - busMooseEntities size) asString;
							 << ' rejected entities.' ]) ].

	"Create the new root query"
	specModel resetRootQueryForEntities: busMooseEntities.
	self updateSelectedQuery.

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
	self initializeQueriesListPresenter.
	self initializeLayout
]

{ #category : #initialization }
MiQueriesBrowser >> initializeQueriesListPresenter [

	queriesListPresenter := self
		                        instantiate: MiQueriesListPresenter
		                        on: specModel
]

{ #category : #initialization }
MiQueriesBrowser >> initializeQueryCodePresenter [

	queryCodePresenter := self instantiate: QueryCodePresenter
]

{ #category : #initialization }
MiQueriesBrowser >> initializeResultTreePresenter [

	queryResultTreePresenter := self newMooseGroupsTreeTable.

	queryResultTreePresenter updateForEntities:
		specModel selectedQueryResult.
	queryResultTreePresenter whenSelectedEntityChangedDo: [
		:selectedEntity | specModel entities: selectedEntity ]
]

{ #category : #brokerage }
MiQueriesBrowser >> itemsFor: aClass [

	^ specModel queriesOfType: aClass
]

{ #category : #accessing }
MiQueriesBrowser >> miSelectedItem [

	^ specModel miSelectedItem
]

{ #category : #accessing }
MiQueriesBrowser >> rootQuery [

	^ specModel rootQuery
]

{ #category : #actions }
MiQueriesBrowser >> selectQuery: aQuery [

	specModel selectedQuery: aQuery.
	self updateSelectedQuery
]

{ #category : #accessing }
MiQueriesBrowser >> selectedQuery [

	^ specModel selectedQuery
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

{ #category : #actions }
MiQueriesBrowser >> updateSelectedQuery [

	specModel resetEntities.
	self updateResultPresenterForQuery: specModel selectedQuery.
	queryCodePresenter updateForQuery: specModel selectedQuery
]
