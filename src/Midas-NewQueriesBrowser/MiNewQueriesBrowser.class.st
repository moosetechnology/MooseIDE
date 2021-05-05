Class {
	#name : #MiNewQueriesBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'queryResultTreePresenter',
		'selectedQuery',
		'queries',
		'queryCodePresenter',
		'queryNotebookPresenter',
		'queryBuilderLayout'
	],
	#category : #'Midas-NewQueriesBrowser-Presenters'
}

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
MiNewQueriesBrowser >> initializeLayout [

	| tempLayout |
	"Initialize the queryBuildeLayout instance variable"
	queryBuilderLayout := SpBoxLayout newTopToBottom.
	
	tempLayout := self class defaultSpec.
	tempLayout add: (SpPanedLayout new
			 add: queryBuilderLayout;
			 add: #queryNotebookPresenter;
			 yourself).
	self layout: tempLayout
]

{ #category : #initialization }
MiNewQueriesBrowser >> initializePresenters [

	super initializePresenters.
	self initializeLayout.
	queryCodePresenter := self instantiate: MiQueryCodePresenter.
	queryResultTreePresenter := self
		                            instantiate: MiResultTreePresenter
		                            on: self.
	queryResultTreePresenter updateForEntities: self queryResultEntities.
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

{ #category : #accessing }
MiNewQueriesBrowser >> queryResultEntities [

	^ selectedQuery result
]

{ #category : #accessing }
MiNewQueriesBrowser >> rootQuery [

	^ queries detect: [ :query | query parent isNil ]
]

{ #category : #action }
MiNewQueriesBrowser >> selectQuery: aQuery [

	selectedQuery := aQuery.
	"queryRossalPresenter selectItem: selectedQuery."
	queryResultTreePresenter updateForQuery: aQuery.
	queryCodePresenter updateForQuery: aQuery.
	self update
]

{ #category : #accessing }
MiNewQueriesBrowser >> selectedQuery [
	^ selectedQuery
]

{ #category : #initialization }
MiNewQueriesBrowser >> setModelBeforeInitialization: aRootQuery [

	queries := OrderedCollection new
		           add: aRootQuery;
		           yourself.
	selectedQuery := self rootQuery
]
