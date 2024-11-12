Class {
	#name : #MiAnalysisPresenter,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'currentBrowser',
		'browserLayout',
		'browsersList'
	],
	#category : #'MooseIDE-Analysis'
}

{ #category : #keymaps }
MiAnalysisPresenter class >> browserKey [

	^ $a
]

{ #category : #'as yet unclassified' }
MiAnalysisPresenter class >> duplicationAnalysis [

	| duplicationTag queryBrowser duplicationBrowser |
	duplicationTag := FamixTag named: 'Duplication'.

	queryBrowser := MiQueriesBrowser new.
	queryBrowser followBus: MiApplication current defaultBus.
	queryBrowser queriesListPresenter constructQueries:
		{ (FQTypeQuery types: { FamixTMethod }) }.

	duplicationBrowser := MiDuplicationBrowser new.
	duplicationBrowser followBus: MiApplication current defaultBus.
	duplicationBrowser resetReplicas.
	duplicationBrowser model findReplicas.
	duplicationBrowser selectedTag: duplicationTag.
	duplicationBrowser tagSelectedEntities.

	^ {
		  queryBrowser.
		  duplicationBrowser }
]

{ #category : #'instance creation' }
MiAnalysisPresenter class >> open [

	<script>
	^ super open
]

{ #category : #'instance creation' }
MiAnalysisPresenter class >> openDuplicationAnalysis [

	<script>
	^ super open
		  addBrowsers: self duplicationAnalysis;
		  yourself
]

{ #category : #specs }
MiAnalysisPresenter class >> title [

	^ 'Moose Analysis'
]

{ #category : #specs }
MiAnalysisPresenter class >> windowSize [

	^ 700 @ 500
]

{ #category : #initialization }
MiAnalysisPresenter >> addBrowserMenu [

	| menu |
	menu := self newMenu.
	(MiAbstractBrowser subclasses sortAscending: [ :browserClass |
		 browserClass menuPriority ]) do: [ :browserClass |
		browserClass
			buildItemInMenu: menu
			action: [ self newBrowser: browserClass ] ].
	^ menu
]

{ #category : #adding }
MiAnalysisPresenter >> addBrowsers: aCollectionOfBrowsers [

	aCollectionOfBrowsers do: [ :browser |
		browsersList addPresenter: (MiBrowserCardPresenter on: browser) ]
]

{ #category : #testing }
MiAnalysisPresenter >> canFollowEntity: anObject [

	^ currentBrowser canFollowEntity: anObject
]

{ #category : #layout }
MiAnalysisPresenter >> defaultLayout [

	^ SpPanedLayout newLeftToRight
		  positionOfSlider: 0.3;
		  add: browsersList;
		  add: (browserLayout := self newBoxLayoutTopToBottom);
		  yourself
]

{ #category : #initialization }
MiAnalysisPresenter >> initialize [

	super initialize.
	self whenDisplayDo: [ browsersList selectFirst ]
]

{ #category : #initialization }
MiAnalysisPresenter >> initializePresenters [

	super initializePresenters.

	browsersList := self newComponentList.

	self newBrowser: MiModelsBrowser.
	self newBrowser: MiTagBrowser.
	browsersList
		contextMenu: [ self addBrowserMenu ];
		whenSelectedItemChangedDo: [ :browserCard |
			self selectedBrowserChanged: (browserCard
						 ifNil: [ MiNullBrowser new ]
						 ifNotNil: [ browserCard browser ]) ]
]

{ #category : #accessing }
MiAnalysisPresenter >> miSelectedItem [

	^ currentBrowser miSelectedItem
]

{ #category : #accessing }
MiAnalysisPresenter >> miSelectedItemToPropagate [

	^ currentBrowser miSelectedItemToPropagate
]

{ #category : #initialization }
MiAnalysisPresenter >> newBrowser: aBrowserClass [

	browsersList addPresenter:
		(MiBrowserCardPresenter on:
			 (aBrowserClass on: aBrowserClass newModel))
]

{ #category : #initialization }
MiAnalysisPresenter >> selectedBrowserChanged: aBrowser [

	currentBrowser := aBrowser.

	browserLayout
		removeAll;
		add: currentBrowser.

	self updateToolbar
]
