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
	#category : #'Midas-NewQueriesBrowser-Main presenters'
}

{ #category : #'world menu' }
MiNewQueriesBrowser class >> menuCommandOn: aBuilder [

	<worldMenu>
	<miBrowsers>
	(aBuilder item: #NewQueries)
		parent: #Moose;
		label: self title;
		order: 4;
		help: self helpMessage;
		action: [ self runMe ]
]

{ #category : #'instance creation' }
MiNewQueriesBrowser class >> new [

	"A MooseGroup is necessary to initialize this presenter"

	^ self on: (FQRootQuery new
			   result: MooseGroup new;
			   yourself)
]

{ #category : #'instance creation' }
MiNewQueriesBrowser class >> newModel [

	^ FQRootQuery new
]

{ #category : #'instance creation' }
MiNewQueriesBrowser class >> runMe [

	<script>
	^ super runMe
]

{ #category : #specs }
MiNewQueriesBrowser class >> title [

	^ 'Queries Browser'
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

{ #category : #accessing }
MiNewQueriesBrowser >> currentQuery [

	^ currentQuery
]

{ #category : #actions }
MiNewQueriesBrowser >> followAction [

	| newCurrentQuery |
	(self accept: toSelect) ifFalse: [ ^ self ].
	toSelect := toSelect asMooseGroup allUsing: FamixTNamedEntity.
	queriesHistory do: #resetResult.
	newCurrentQuery := self getRootQuery
		                   result: toSelect;
		                   name: toSelect first mooseModel name;
		                   yourself.
	queriesHistory := OrderedCollection new.
	self updateForQuery: newCurrentQuery.
	queryBuilderPresenter followAction: newCurrentQuery
]

{ #category : #accessing }
MiNewQueriesBrowser >> getRootQuery [

	^ queriesHistory detect: [ :query | query parent isNil ]
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

	queryNotebookPresenter := self newNotebook
		                          pages: { 
				                          (SpNotebookPage
					                           title: 'Result of current query'
					                           provider: [ queryResultTreePresenter ]).
				                          (SpNotebookPage
					                           title: 'Current query code'
					                           provider: [ queryCodePresenter ]) };
		                          yourself
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

{ #category : #api }
MiNewQueriesBrowser >> queryChangedUpdate: query [

	self selectQuery: query
]

{ #category : #accessing }
MiNewQueriesBrowser >> queryResultEntities [

	^ currentQuery result
]

{ #category : #api }
MiNewQueriesBrowser >> removeQuery: aQuery [

	self selectQuery: queriesHistory last.
	queriesHistory removeLast
	"rootQuery children ifNotEmpty: [ 
		UIManager default alert:
			'Cannot remove a query with children for now'.
		^ self ].
	rootQuery prepareRemovalFrom: self.
	queries remove: rootQuery"
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

	"This methods is only for backwards compatibility with the old queries browser"

	^ self currentQuery
]

{ #category : #'accessing model' }
MiNewQueriesBrowser >> setModelBeforeInitialization: aRootQuery [

	queriesHistory := OrderedCollection new
		                            add: aRootQuery;
		                            yourself.
	currentQuery := self getRootQuery
]

{ #category : #api }
MiNewQueriesBrowser >> updateForQuery: aQuery [

	"This method is called from FQQueryCreationPresenter and FQQueriesCombinationPresenter. 
	They have the responsibility to establish the [parent* - child] relationship between queries"

	"currentQuery addChild: query"

	queriesHistory addLast: aQuery.
	self selectQuery: aQuery
]
