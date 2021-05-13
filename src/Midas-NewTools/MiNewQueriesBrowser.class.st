"
I am a midas browser that allows to create custom queries that applies to a MooseModel. I have a `Mi
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
		'currentQuery',
		'queriesHistory'
	],
	#category : #'Midas-NewTools-Queries Browser'
}

{ #category : #'world menu' }
MiNewQueriesBrowser class >> menuCommandOn: aBuilder [

	<worldMenu>
	<miBrowsers>
	(aBuilder item: #NewQueries)
		parent: #Moose;
		label: self title;
		order: 7;
		help: self helpMessage;
		action: [ self runMe ];
		withSeparatorAfter
]

{ #category : #'instance creation' }
MiNewQueriesBrowser class >> newModel [

	^ FQRootQuery new
]

{ #category : #'instance creation' }
MiNewQueriesBrowser class >> runMe [

	"This method implementation is the same as their parent. But it is here for opening this browser more confortably from the system's browser."

	<script>
	^ super runMe
]

{ #category : #specs }
MiNewQueriesBrowser class >> title [

	^ 'New Queries Browser'
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

{ #category : #'api - actions' }
MiNewQueriesBrowser >> addNewQuery: aQuery [

	queriesHistory addLast: aQuery.
	self selectQuery: aQuery
]

{ #category : #accessing }
MiNewQueriesBrowser >> currentQuery [

	^ currentQuery
]

{ #category : #actions }
MiNewQueriesBrowser >> followAction [

	| newQuery mooseModelName |
	(self accept: toSelect) ifFalse: [ ^ self ].
	"Update window's title"
	mooseModelName := toSelect first mooseModel name.
	self window title: (self getTitle: mooseModelName).

	"Create the new query "
	queriesHistory do: #resetResult.
	toSelect := toSelect asMooseGroup allUsing: FamixTNamedEntity.
	newQuery := self getRootQuery
		            result: toSelect;
		            name: mooseModelName;
		            yourself.
	"Clear the queries history"
	queriesHistory := OrderedCollection empty.
	"Update the all the sub presenters with this new query"
	self addNewQuery: newQuery.
	queryBuilderPresenter followAction
]

{ #category : #accessing }
MiNewQueriesBrowser >> getRootQuery [

	^ queriesHistory detect: [ :query | query parent isNil ]
]

{ #category : #accessing }
MiNewQueriesBrowser >> getTitle: mooseModelName [

	^ self class title , ' (' , mooseModelName , ')'
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
	self initializeLayout.
	self initializeQueryCodePresenter.
	self initializeResultTreePresenter.
	self initializeNotebookPresenter.
	self initializeQueryBuilder
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
		             currentQuery result ]) specialize.
	^ selected size = 1
		  ifTrue: [ selected anyOne ]
		  ifFalse: [ selected ]
]

{ #category : #'as yet unclassified' }
MiNewQueriesBrowser >> queriesHistory [

	^ queriesHistory
]

{ #category : #'api - actions' }
MiNewQueriesBrowser >> queryChangedUpdate: query [

	self selectQuery: query
]

{ #category : #accessing }
MiNewQueriesBrowser >> queryResultEntities [

	^ currentQuery result
]

{ #category : #'as yet unclassified' }
MiNewQueriesBrowser >> queryResultTreePresenter [

	^ queryResultTreePresenter
]

{ #category : #'api - actions' }
MiNewQueriesBrowser >> removeQuery: aQuery [

	self selectQuery: queriesHistory last.
	queriesHistory removeLast
]

{ #category : #actions }
MiNewQueriesBrowser >> selectQuery: aQuery [

	currentQuery := aQuery.
	queryResultTreePresenter updateForQuery: aQuery.
	queryCodePresenter updateForQuery: aQuery.
	self update
]

{ #category : #accessing }
MiNewQueriesBrowser >> selectedQuery [

	"This method is only for backwards compatibility with the old queries browser"

	^ self currentQuery
]

{ #category : #'accessing model' }
MiNewQueriesBrowser >> setModelBeforeInitialization: aRootQuery [

	queriesHistory := OrderedCollection with: aRootQuery.
	currentQuery := self getRootQuery
]
