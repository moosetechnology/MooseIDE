Class {
	#name : #MiAnalysisPresenter,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'currentBrowser',
		'browserLayout',
		'browsers',
		'browsersListPresenter'
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
			action: [ self newBrowser: browserClass new ] ].
	^ menu
]

{ #category : #adding }
MiAnalysisPresenter >> addBrowsers: aCollectionOfBrowsers [

	aCollectionOfBrowsers do: [ :browser | self newBrowser: browser ]
]

{ #category : #accessing }
MiAnalysisPresenter >> browsers [

	^ browsers ifNil: [ browsers := self initialBrowsers ]
]

{ #category : #testing }
MiAnalysisPresenter >> canFollowEntity: anObject [

	^ currentBrowser canFollowEntity: anObject
]

{ #category : #layout }
MiAnalysisPresenter >> defaultLayout [

	^ SpPanedLayout newLeftToRight
		  positionOfSlider: 0.3;
		  add: browsersListPresenter;
		  add: (browserLayout := self newBoxLayoutTopToBottom);
		  yourself
]

{ #category : #accessing }
MiAnalysisPresenter >> initialBrowsers [

	| modelsBrowser tagBrowser |
	modelsBrowser := MiModelsBrowser new.
	tagBrowser := MiTagBrowser new receiveEntity:
		              modelsBrowser miSelectedItem.

	^ OrderedCollection withAll: {
			  modelsBrowser.
			  tagBrowser }
]

{ #category : #initialization }
MiAnalysisPresenter >> initialize [

	super initialize.

	self whenDisplayDo: [ browsersListPresenter selectFirst ]
]

{ #category : #initialization }
MiAnalysisPresenter >> initializePresenters [

	super initializePresenters.

	browsersListPresenter := self newComponentList.
	browsersListPresenter
		items: (self browsers collect: [ :browser |
					 MiBrowserCardPresenter on: browser ]);
		contextMenu: [ self addBrowserMenu ];
		whenSelectedItemChangedDo: [ :browserCard |
			self selectedBrowserChanged: (browserCard
						 ifNil: [ MiNullBrowser new ]
						 ifNotNil: [ browserCard browser ]) ]
]

{ #category : #accessing }
MiAnalysisPresenter >> miSelectedItem [

	^ currentBrowser ifNotNil: [ currentBrowser miSelectedItem ]
]

{ #category : #accessing }
MiAnalysisPresenter >> miSelectedItemToPropagate [

	^ currentBrowser miSelectedItemToPropagate
]

{ #category : #initialization }
MiAnalysisPresenter >> newBrowser: aBrowser [

	browsers ifNotEmpty: [
		aBrowser receiveEntity:
			browsers last miSelectedItem mooseInterestingEntity ].

	browsers add: aBrowser.
	browsersListPresenter addPresenter:
		(MiBrowserCardPresenter on: aBrowser)
]

{ #category : #action }
MiAnalysisPresenter >> propagateLocallyFrom: aBrowser [

	| target |
	target := browsers after: aBrowser ifAbsent: [ ^ self ].
	target receiveEntity:
		aBrowser miSelectedItemToPropagate mooseInterestingEntity
]

{ #category : #removing }
MiAnalysisPresenter >> remove: aBrowser [

	browsers remove: aBrowser.
	browsersListPresenter items:
		(browsers collect: [ :browser | MiBrowserCardPresenter on: browser ])
]

{ #category : #initialization }
MiAnalysisPresenter >> selectedBrowserChanged: aBrowser [

	currentBrowser := aBrowser.

	browserLayout
		removeAll;
		add: currentBrowser.

	self updateToolbar
]
