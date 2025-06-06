"
Shows an overview of the current Midas state:
- All opened browsers
- All buses.

Centralizes bus and browser creation and managment.

"
Class {
	#name : #MiOverviewBrowser,
	#superclass : #MiPresenter,
	#instVars : [
		'browsersPage',
		'busesPage',
		'browsersListPresenter',
		'busesListPresenter',
		'mainPresenter',
		'toolbar'
	],
	#category : #'MooseIDE-Core-Overview'
}

{ #category : #height }
MiOverviewBrowser class >> browsersTabHeight [

	^ self currentApplication browsers size * self toolbarHeight
	  + (self currentApplication browsers size
		   * (1 max: self currentApplication buses size)
		   * self tableLineHeight)
]

{ #category : #height }
MiOverviewBrowser class >> busesTabHeight [

	^ self currentApplication buses size * self toolbarHeight
	  + (self currentApplication buses size
		   * (1 max: self currentApplication browsers size)
		   * self tableLineHeight)
]

{ #category : #height }
MiOverviewBrowser class >> defaultHeight [

	^ 400
]

{ #category : #height }
MiOverviewBrowser class >> emptyBrowserHeight [

	^ 75
]

{ #category : #height }
MiOverviewBrowser class >> height [

	^ (self busesTabHeight max: self browsersTabHeight)
	  + self emptyBrowserHeight max: self defaultHeight
]

{ #category : #'world menu' }
MiOverviewBrowser class >> helpMessage [

	^ (self comment lines copyUpTo: '') fold: [ :s1 :s2 | 
		  s1 , Character cr asString , s2 ]
]

{ #category : #'world menu' }
MiOverviewBrowser class >> menuCommandOn: aBuilder [

	<worldMenu>
	(aBuilder item: self menuItem)
		parent: self menuParent;
		label: self menuLabel;
		icon: self menuIcon;
		help: self helpMessage;
		action: [ self open ];
		order: self menuPriority
]

{ #category : #'world menu' }
MiOverviewBrowser class >> menuIcon [

	^ MooseIcons mooseIcon
]

{ #category : #'world menu' }
MiOverviewBrowser class >> menuItem [

	^ #MiOverview
]

{ #category : #'world menu' }
MiOverviewBrowser class >> menuLabel [

	^ self title
]

{ #category : #'world menu' }
MiOverviewBrowser class >> menuParent [

	^ MiAbstractBrowser menuParent
]

{ #category : #'world menu' }
MiOverviewBrowser class >> menuPriority [

	^ MiAbstractBrowser menuMainToolsPriority + 1
]

{ #category : #specs }
MiOverviewBrowser class >> open [

	<script>
	self new open
]

{ #category : #specs }
MiOverviewBrowser class >> title [

	^ 'MooseIDE Overview'
]

{ #category : #presenters }
MiOverviewBrowser >> addBrowser: aMiPresenterClass asPage: aString [

	| spPage |
	spPage := self
		pageNamed: aString
		presenter: [ (aMiPresenterClass owner: self on: aMiPresenterClass newModel)
			followBus: self application defaultBus ;
			yourself ].

	spPage beCloseable.
	
	mainPresenter addPage: spPage.
	^spPage
]

{ #category : #toolbar }
MiOverviewBrowser >> browsersMenu [

	^ MiAbstractBrowser miBrowsersMenuPresenter
]

{ #category : #accessing }
MiOverviewBrowser >> buses [

	^ self application buses
]

{ #category : #layout }
MiOverviewBrowser >> defaultLayout [

	^ SpBoxLayout newVertical
		  spacing: 10;
		  add: toolbar height: self class toolbarHeight;
		  add: mainPresenter;
		  yourself
]

{ #category : #actions }
MiOverviewBrowser >> followBus: aBus [

	self updateBusesPage
]

{ #category : #initialization }
MiOverviewBrowser >> initializeBrowsersList [

	browsersListPresenter := self newComponentList
		propagateNaturalHeight: true;
		items: self openedBrowsers;
		sortingBlock: [ :a :b | a toolbarLabel < b toolbarLabel ];
		whenSelectionChangedDo: [ :selection |
			selection selectedItem ifNotNil: [ :object | object highlightWindow] ] 
]

{ #category : #initialization }
MiOverviewBrowser >> initializeBrowsersPage [

	self initializeBrowsersList.
	
	browsersPage := self
		pageNamed: 'Browsers'
		presenter: [ browsersListPresenter ]
]

{ #category : #initialization }
MiOverviewBrowser >> initializeBusesList [

	 busesListPresenter :=  self newComponentList
		  propagateNaturalHeight: true;
		  items: (self application buses collect: [ :bus | MiBusPresenter on: bus ]);
		  sortingBlock: [ :a :b | a toolbarLabel < b toolbarLabel ] 
]

{ #category : #initialization }
MiOverviewBrowser >> initializeBusesPage [

	self initializeBusesList.
	busesPage := self pageNamed: 'Buses' presenter: [ busesListPresenter ]
]

{ #category : #initialization }
MiOverviewBrowser >> initializeNotebook [

	mainPresenter := self newNotebook.
	
	self initializeBrowsersPage.
	self initializeBusesPage.
	
	mainPresenter addPage: browsersPage.
	mainPresenter addPage: busesPage
]

{ #category : #initialization }
MiOverviewBrowser >> initializePresenters [

	self initializeToolbar.
	self initializeNotebook
]

{ #category : #initialization }
MiOverviewBrowser >> initializeToolbar [

	toolbar := self newToolbar.

	toolbar add: (MiEditBusCommand forSpecContext: self) buildPresenter.

	toolbar add: (SpToolbarButtonPresenter new
			 icon: MooseIcons mooseIcon;
			 label: 'Open new browser';
			 action: [ self browsersMenu openWithSpecAtPointer ];
			 yourself).

	toolbar addItemRight:
		(MiHelpCommand forSpecContext: self) buildPresenter
]

{ #category : #initialization }
MiOverviewBrowser >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter initialExtent: 500 @ self class height
]

{ #category : #presenters }
MiOverviewBrowser >> openedBrowsers [

	^ self application openedBrowsers asOrderedCollection
		collect: [ :browser | MiBrowserPresenter on: browser ]
]

{ #category : #presenters }
MiOverviewBrowser >> pageNamed: aName presenter: aComponentList [
	^ self newNotebookPage
		title: aName;
		presenterProvider: aComponentList;
		yourself
]

{ #category : #toolbar }
MiOverviewBrowser >> replaceMenuItemAction: aMenuItem [

	| itemAction |
	itemAction := aMenuItem action.

	aMenuItem action: [ itemAction value ]
]

{ #category : #actions }
MiOverviewBrowser >> unfollowBus: aBus [

	self updateBusesPage
]

{ #category : #actions }
MiOverviewBrowser >> updateBrowsersListItems [

	browsersListPresenter items: self openedBrowsers
]

{ #category : #actions }
MiOverviewBrowser >> updateBusesPage [

	busesListPresenter items:
		(self application buses collect: [ :bus | MiBusPresenter on: bus ])
]
