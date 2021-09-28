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

{ #category : #testing }
MiQueriesBrowser >> canReceiveEntity: anObject [

	^ anObject isMooseObject and: [ 
		  (anObject asMooseGroup allUsing: FamixTNamedEntity) isNotEmpty ]
]

{ #category : #actions }
MiQueriesBrowser >> followEntity: anEntity [

	| mooseGroup mooseModelName |
	"Create a group in case that only one entity was received from the bus"
	mooseGroup := anEntity asMooseGroup allUsing: FamixTNamedEntity.

	"Update window's title"
	mooseModelName := mooseGroup first mooseModel name.
	self window title: (self class titleForModelName: mooseModelName).

	"Create the new root query"
	"rootQuery children removeAll."
	rootQuery
		resetResult;
		result: mooseGroup;
		name: mooseModelName.

	"Update the all the sub presenters with this new query"
	self selectQuery: rootQuery.
	queriesListPresenter followAction
]

{ #category : #initialization }
MiQueriesBrowser >> initializeLayout [

	| tempLayout |
	tempLayout := self class defaultSpec.
	tempLayout add: (SpPanedLayout new
			 add: #queriesListPresenter;
			 add: #queryNotebookPresenter;
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

	super initializePresenters.
	self initializeQueryCodePresenter.
	self initializeResultTreePresenter.
	self initializeNotebookPresenter.
	self initializeQueryBuilder.
	self initializeLayout
]

{ #category : #initialization }
MiQueriesBrowser >> initializeQueryBuilder [

	queriesListPresenter := self instantiate:
		                         (MiQueriesListPresenter on: self)
]

{ #category : #initialization }
MiQueriesBrowser >> initializeQueryCodePresenter [

	queryCodePresenter := self instantiate: MiQueryCodePresenter
]

{ #category : #initialization }
MiQueriesBrowser >> initializeResultTreePresenter [

	queryResultTreePresenter := self instantiate: MiResultTreePresenter.
	queryResultTreePresenter updateForEntities: self queryResultEntities
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

	self removeChild: aQuery fromParent: rootQuery
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

{ #category : #'accessing model' }
MiQueriesBrowser >> setModelBeforeInitialization: aRootQuery [

	rootQuery := aRootQuery.
	selectedQuery := aRootQuery
]
