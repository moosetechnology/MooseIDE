"
I am a MooseIDE browser that allows to create custom queries that applies to a MooseModel. I have a `Mi
queryBuilderPresenter` instance variable that contains a list with all the queries that you want to apply to the Moose model.
"
Class {
	#name : #MiNewQueriesBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'queryResultTreePresenter',
		'queryCodePresenter',
		'queryNotebookPresenter',
		'queryBuilderPresenter',
		'selectedQuery',
		'rootQuery'
	],
	#category : #'MooseIDE-NewTools-Queries Browser'
}

{ #category : #'world menu' }
MiNewQueriesBrowser class >> menuCommandOn: aBuilder [

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
MiNewQueriesBrowser class >> newModel [

	^ FQRootQuery new
]

{ #category : #'instance creation' }
MiNewQueriesBrowser class >> open [

	"This method implementation is the same as their parent. But it is here for opening this browser more confortably from the system's browser."

	<script>
	^ super open
]

{ #category : #specs }
MiNewQueriesBrowser class >> title [

	^ 'Queries Browser'
]

{ #category : #accessing }
MiNewQueriesBrowser class >> titleForModelName: mooseModelName [

	^ self title , ' (' , mooseModelName , ')'
]

{ #category : #specs }
MiNewQueriesBrowser class >> windowSize [

	^ 650 @ 420
]

{ #category : #testing }
MiNewQueriesBrowser >> accept: anObject [

	^ anObject isMooseObject and: [ 
		  (anObject asMooseGroup allUsing: FamixTNamedEntity) isNotEmpty ]
]

{ #category : #actions }
MiNewQueriesBrowser >> followAction [

	| mooseModelName |
	(self accept: toSelect) ifFalse: [ ^ self ].
	"Create a group in case that only one entity was received from the bus"
	toSelect := toSelect asMooseGroup allUsing: FamixTNamedEntity.

	"Update window's title"
	mooseModelName := toSelect first mooseModel name.
	self window title: (self class titleForModelName: mooseModelName).

	"Create the new root query"
	rootQuery children removeAll.
	rootQuery
		resetResult;
		result: toSelect;
		name: mooseModelName.

	"Update the all the sub presenters with this new query"
	self selectQuery: rootQuery.
	queryBuilderPresenter followAction
]

{ #category : #initialization }
MiNewQueriesBrowser >> initializeLayout [

	| tempLayout |
	tempLayout := self class defaultSpec.
	tempLayout add: (SpPanedLayout new
			 add: #queryBuilderPresenter;
			 add: #queryNotebookPresenter;
			 yourself).
	self layout: tempLayout
]

{ #category : #initialization }
MiNewQueriesBrowser >> initializeNotebookPresenter [

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
MiNewQueriesBrowser >> initializePresenters [

	super initializePresenters.
	self initializeQueryCodePresenter.
	self initializeResultTreePresenter.
	self initializeNotebookPresenter.
	self initializeQueryBuilder.
	self initializeLayout
]

{ #category : #initialization }
MiNewQueriesBrowser >> initializeQueryBuilder [

	queryBuilderPresenter := self instantiate:
		                         (MiQueryBuilderPresenter on: self)
]

{ #category : #initialization }
MiNewQueriesBrowser >> initializeQueryCodePresenter [

	queryCodePresenter := self instantiate: MiQueryCodePresenter
]

{ #category : #initialization }
MiNewQueriesBrowser >> initializeResultTreePresenter [

	queryResultTreePresenter := self
		                            instantiate: MiResultTreePresenter
		                            on: self.
	queryResultTreePresenter updateForEntities: self queryResultEntities
]

{ #category : #accessing }
MiNewQueriesBrowser >> miSelectedItem [

	| selected |
	selected := (queryResultTreePresenter miSelectedItem ifEmpty: [ 
		             selectedQuery result ]) specialize.
	^ selected size = 1
		  ifTrue: [ selected anyOne ]
		  ifFalse: [ selected ]
]

{ #category : #'api - actions' }
MiNewQueriesBrowser >> queryChangedUpdate: query [

	self selectQuery: query
]

{ #category : #accessing }
MiNewQueriesBrowser >> queryResultEntities [

	^ selectedQuery result
]

{ #category : #removing }
MiNewQueriesBrowser >> removeChild: childToRemove fromNode: aNode [

	(aNode children includes: childToRemove) ifTrue: [ 
		aNode removeChild: childToRemove.
		^ self ].
	aNode children do: [ :aChild | 
		self removeChild: childToRemove fromNode: aChild ]
]

{ #category : #'api - actions' }
MiNewQueriesBrowser >> removeQuery: aQuery [

	self removeChild: aQuery fromNode: rootQuery
]

{ #category : #accessing }
MiNewQueriesBrowser >> rootQuery [
	^ rootQuery
]

{ #category : #actions }
MiNewQueriesBrowser >> selectQuery: aQuery [

	selectedQuery := aQuery.
	queryResultTreePresenter updateForQuery: aQuery.
	queryCodePresenter updateForQuery: aQuery.
	self update
]

{ #category : #'accessing model' }
MiNewQueriesBrowser >> setModelBeforeInitialization: aRootQuery [

	rootQuery := aRootQuery.
	selectedQuery := aRootQuery
]
