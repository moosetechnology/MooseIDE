Class {
	#name : #MiPreviewBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'queryPresenters',
		'titlePresenter'
	],
	#category : #'MooseIDE-Preview-Browser'
}

{ #category : #accessing }
MiPreviewBrowser class >> menuCommandOn: aBuilder [

	<worldMenu>
	^ self buildMenuItemIn: aBuilder
]

{ #category : #accessing }
MiPreviewBrowser class >> menuItem [

	^ #MiPreviewBrowser
]

{ #category : #accessing }
MiPreviewBrowser class >> menuPriority [

	^ self menuVisualizationToolsPriority + 1
]

{ #category : #'instance creation' }
MiPreviewBrowser class >> newModel [

	^ MiPreviewModel new
]

{ #category : #accessing }
MiPreviewBrowser class >> open [
	<script>
	super open
]

{ #category : #accessing }
MiPreviewBrowser class >> title [

	^ 'Queries dashboard'
]

{ #category : #testing }
MiPreviewBrowser >> canFollowEntity: anObject [

	^ anObject isMooseObject
]

{ #category : #actions }
MiPreviewBrowser >> followEntity: anEntity [

	specModel mooseModel: (anEntity isMooseModel
			 ifTrue: [ anEntity ]
			 ifFalse: [ anEntity mooseModel ]).
	self updatePresenters
]

{ #category : #actions }
MiPreviewBrowser >> getQueries [

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
MiPreviewBrowser >> initialize [

	super initialize.
	queryPresenters := OrderedCollection new.
]

{ #category : #initialization }
MiPreviewBrowser >> initializeLayout [

	self layout: (SpBoxLayout newTopToBottom
			 vAlignCenter;
			 hAlignCenter;
			 add: 'There are no queries for this model.' asPresenter;
			 yourself)
]

{ #category : #initialization }
MiPreviewBrowser >> initializePresenters [

	titlePresenter := self newLabel
		                  label: 'Available queries';
		                  addStyle: 'titleLabel';
		                  yourself.
	self initializeLayout
]

{ #category : #initialization }
MiPreviewBrowser >> initializeWindow: aMiWindowPresenter [

	super initializeWindow: aMiWindowPresenter.
	aMiWindowPresenter initialExtent: 800@500
]

{ #category : #initialization }
MiPreviewBrowser >> miSelectedItem [

	^ nil
]

{ #category : #accessing }
MiPreviewBrowser >> selectedTag [

	^ nil 
]

{ #category : #initialization }
MiPreviewBrowser >> setModelBeforeInitialization: aBrowserModel [

	aBrowserModel ifNil: [ ^ self ].

	specModel := aBrowserModel
]

{ #category : #actions }
MiPreviewBrowser >> updatePresenters [

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
