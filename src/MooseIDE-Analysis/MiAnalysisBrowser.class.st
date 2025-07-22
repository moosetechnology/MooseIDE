Class {
	#name : 'MiAnalysisBrowser',
	#superclass : 'MiAbstractBrowser',
	#instVars : [
		'currentBrowser',
		'browserLayout',
		'browsers',
		'browsersListPresenter'
	],
	#category : 'MooseIDE-Analysis-Browser',
	#package : 'MooseIDE-Analysis',
	#tag : 'Browser'
}

{ #category : 'keymaps' }
MiAnalysisBrowser class >> browserKey [

	^ $a
]

{ #category : 'as yet unclassified' }
MiAnalysisBrowser class >> duplicationAnalysis [

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

{ #category : 'world menu' }
MiAnalysisBrowser class >> menuCommandOn: aBuilder [

	<worldMenu>
	<miBrowsersMenu>
	^ self buildMenuItemIn: aBuilder
]

{ #category : 'world menu' }
MiAnalysisBrowser class >> menuItem [

	^ #AnalysisBrowser
]

{ #category : 'world menu' }
MiAnalysisBrowser class >> menuPriority [

	^ self menuMainToolsPriority + 6
]

{ #category : 'instance creation' }
MiAnalysisBrowser class >> open [

	<script>
	^ super open
]

{ #category : 'instance creation' }
MiAnalysisBrowser class >> openDuplicationAnalysis [

	<script>
	^ super open
		  addBrowsers: self duplicationAnalysis;
		  yourself
]

{ #category : 'specs' }
MiAnalysisBrowser class >> preferredExtent [

	^ 700 @ 500
]

{ #category : 'specs' }
MiAnalysisBrowser class >> title [

	^ 'Moose Analysis'
]

{ #category : 'initialization' }
MiAnalysisBrowser >> addBrowserMenu [

	^ MiAbstractBrowser
		  allBrowsersMenuRoot: self newMenu
		  action: [ :browserClass | self newBrowser: browserClass new ]
]

{ #category : 'adding' }
MiAnalysisBrowser >> addBrowsers: aCollectionOfBrowsers [

	aCollectionOfBrowsers do: [ :browser | self newBrowser: browser ]
]

{ #category : 'accessing' }
MiAnalysisBrowser >> browsers [

	^ browsers ifNil: [ browsers := self initialBrowsers ]
]

{ #category : 'testing' }
MiAnalysisBrowser >> canFollowEntity: anObject [

	^ currentBrowser canFollowEntity: anObject
]

{ #category : 'layout' }
MiAnalysisBrowser >> defaultLayout [

	^ SpPanedLayout newLeftToRight
		  positionOfSlider: 0.3;
		  add: browsersListPresenter;
		  add: (browserLayout := self newBoxLayoutTopToBottom);
		  yourself
]

{ #category : 'accessing' }
MiAnalysisBrowser >> initialBrowsers [

	| modelsBrowser tagBrowser |
	modelsBrowser := MiModelsBrowser new.
	tagBrowser := MiTagBrowser new receiveEntity:
		              modelsBrowser miSelectedItem.

	^ OrderedCollection withAll: {
			  modelsBrowser.
			  tagBrowser }
]

{ #category : 'initialization' }
MiAnalysisBrowser >> initialize [

	super initialize.

	self whenDisplayDo: [ browsersListPresenter selectFirst ]
]

{ #category : 'initialization' }
MiAnalysisBrowser >> initializePresenters [

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

{ #category : 'accessing' }
MiAnalysisBrowser >> miSelectedItem [

	^ currentBrowser ifNotNil: [ currentBrowser miSelectedItem ]
]

{ #category : 'accessing' }
MiAnalysisBrowser >> miSelectedItemToPropagate [

	^ currentBrowser miSelectedItemToPropagate
]

{ #category : 'initialization' }
MiAnalysisBrowser >> newBrowser: aBrowser [

	browsers ifNotEmpty: [
		aBrowser receiveEntity:
			browsers last miSelectedItem mooseInterestingEntity ].

	browsers add: aBrowser.
	browsersListPresenter addPresenter:
		(MiBrowserCardPresenter on: aBrowser)
]

{ #category : 'action' }
MiAnalysisBrowser >> propagateLocallyFrom: aBrowser [

	| target |
	target := browsers after: aBrowser ifAbsent: [ ^ self ].
	target receiveEntity:
		aBrowser miSelectedItemToPropagate mooseInterestingEntity
]

{ #category : 'removing' }
MiAnalysisBrowser >> remove: aBrowser [

	browsers remove: aBrowser.
	browsersListPresenter items:
		(browsers collect: [ :browser | MiBrowserCardPresenter on: browser ])
]

{ #category : 'initialization' }
MiAnalysisBrowser >> selectedBrowserChanged: aBrowser [

	currentBrowser := aBrowser.

	browserLayout
		removeAll;
		add: currentBrowser.

	self updateToolbar
]
