"
I present queries associated with a model.
Accepted entities: any moose object, the moose model is accessed from it.

It looks for queries that could be applied on the model using subclasses of MiAbstractQueriesHolder.
"
Class {
	#name : #MiQueriesDashboardBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'queryPresenters',
		'titlePresenter'
	],
	#category : #'MooseIDE-QueriesDashboard-Browser'
}

{ #category : #accessing }
MiQueriesDashboardBrowser class >> menuCommandOn: aBuilder [

	<worldMenu>
	<miBrowsersMenu>
	^ self buildMenuItemIn: aBuilder
]

{ #category : #accessing }
MiQueriesDashboardBrowser class >> menuItem [

	^ #MiQueriesDashboardBrowser
]

{ #category : #accessing }
MiQueriesDashboardBrowser class >> menuPriority [

	^ self menuVisualizationToolsPriority + 1
]

{ #category : #'instance creation' }
MiQueriesDashboardBrowser class >> newModel [

	^ MiQueriesDashboardModel new
]

{ #category : #accessing }
MiQueriesDashboardBrowser class >> open [
	<script>
	super open
]

{ #category : #accessing }
MiQueriesDashboardBrowser class >> title [

	^ 'Queries dashboard'
]

{ #category : #specs }
MiQueriesDashboardBrowser class >> windowSize [

	^ 800 @ 500
]

{ #category : #testing }
MiQueriesDashboardBrowser >> canFollowEntity: anObject [

	^ anObject isMooseObject
]

{ #category : #actions }
MiQueriesDashboardBrowser >> followEntity: anEntity [

	super followEntity: anEntity.
	specModel mooseModel: (anEntity isMooseModel
			 ifTrue: [ anEntity ]
			 ifFalse: [ anEntity mooseModel ]).
	self updatePresenters
]

{ #category : #actions }
MiQueriesDashboardBrowser >> getQueries [

	| qh qhClass queries results |
	qhClass := MiAbstractQueriesHolder subclasses
		           detect: [ :c | c canBeAppliedOnModel: specModel mooseModel ]
		           ifNone: [ nil ].
	qhClass ifNil: [ ^ {  } ].
	qh := qhClass new
		      mooseModel: specModel mooseModel;
		      yourself.

	queries := qhClass methods select: [ :m | 
		           m pragmas anySatisfy: [ :p | p selector = #query ] ].
	results := queries collect: [ :q | qh perform: q selector ].
	^ results
]

{ #category : #actions }
MiQueriesDashboardBrowser >> initialize [

	super initialize.
	queryPresenters := OrderedCollection new.
]

{ #category : #initialization }
MiQueriesDashboardBrowser >> initializeLayout [

	self layout: (SpBoxLayout newTopToBottom
			 vAlignCenter;
			 hAlignCenter;
			 add: 'There are no queries for this model.' asPresenter;
			 yourself)
]

{ #category : #initialization }
MiQueriesDashboardBrowser >> initializePresenters [

	titlePresenter := self newLabel
		                  label: 'Available queries';
		                  addStyle: 'titleLabel';
		                  yourself.
	self initializeLayout
]

{ #category : #initialization }
MiQueriesDashboardBrowser >> miSelectedItem [

	^ nil
]

{ #category : #accessing }
MiQueriesDashboardBrowser >> selectedTag [

	^ nil 
]

{ #category : #initialization }
MiQueriesDashboardBrowser >> setModelBeforeInitialization: aBrowserModel [

	aBrowserModel ifNil: [ ^ self ].

	specModel := aBrowserModel
]

{ #category : #actions }
MiQueriesDashboardBrowser >> updatePresenters [

	| results newLayout groups |
	queryPresenters := OrderedCollection new.
	results := self getQueries.
	results ifEmpty: [ ^self ].
	newLayout := SpBoxLayout newTopToBottom
		             spacing: 5;
		             yourself.

	groups := (results groupedBy: [ :q | q group ]) associations.
	groups sort: [ :a :b | a key > b key ].

	groups do: [ :g | 
		newLayout
			add: (g key asPresenter
					 addStyle: 'title1';
					 yourself)
			expand: false.
		g value do: [ :r | 
			| newPresenter |
			newPresenter := self instantiate: MiQueryResultPresenter on: r.
			queryPresenters add: newPresenter.
			newLayout add: newPresenter expand: false ] ].


	self layout: (SpBoxLayout newTopToBottom
			 "add: titlePresenter withConstraints: [ :consts | 
				 consts
					 expand: false;
					 padding: 2 ];"
			 add: (self newLabel
					  addStyle: 'hSep';
					  yourself)
			 expand: false;
			 add: (SpScrollableLayout with: newLayout);
			 yourself).
	self announceDisplayed
]
