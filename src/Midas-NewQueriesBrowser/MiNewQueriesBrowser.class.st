Class {
	#name : #MiNewQueriesBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'queryResultTreePresenter',
		'currentQuery',
		'queries',
		'queryCodePresenter',
		'queryNotebookPresenter',
		'queryComponentListPresenter',
		'queryBuilderPresenter'
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

{ #category : #adding }
MiNewQueriesBrowser >> addChildToQuery: query [

	Halt now.
	currentQuery addChild: query
]

{ #category : #accessing }
MiNewQueriesBrowser >> currentQuery [

	^ currentQuery
]

{ #category : #actions }
MiNewQueriesBrowser >> followAction [

	| rootQuery |
	(self accept: toSelect) ifFalse: [ ^ self ].
	toSelect := toSelect asMooseGroup allUsing: FamixTNamedEntity.
	queries do: #resetResult.
	rootQuery := self rootQuery.
	rootQuery
		result: toSelect;
		name: toSelect first mooseModel name.
	self selectQuery: rootQuery
]

{ #category : #initialization }
MiNewQueriesBrowser >> initializeComponentList [

	queryComponentListPresenter := self newComponentList.
	queryComponentListPresenter
		propagateNaturalHeight: true;
		presenters: { (MiNewQueryCreationPresenter on: self) }
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

{ #category : #accessing }
MiNewQueriesBrowser >> queryCodePresenter [

	^ queryCodePresenter
]

{ #category : #accessing }
MiNewQueriesBrowser >> queryResultEntities [

	^ currentQuery result
]

{ #category : #accessing }
MiNewQueriesBrowser >> queryResultTreePresenter [

	^ queryResultTreePresenter
]

{ #category : #accessing }
MiNewQueriesBrowser >> rootQuery [

	^ queries detect: [ :query | query parent isNil ]
]

{ #category : #action }
MiNewQueriesBrowser >> selectQuery: aQuery [

	currentQuery := aQuery.
	"queryRossalPresenter selectItem: selectedQuery."
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

	queries := OrderedCollection new
		           add: aRootQuery;
		           yourself.
	currentQuery := self rootQuery
]
