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
		'busesButton',
		'browsersButton',
		'chkOpenInPage',
		'helpButton',
		'browsersPage',
		'busesPage',
		'browsersListPresenter',
		'busesListPresenter',
		'mainPresenter'
	],
	#category : #'MooseIDE-Core-Overview'
}

{ #category : #height }
MiOverviewBrowser class >> browsersTabHeight [
	^ self currentApplication browsers size * self toolbarHeight
		+
			(self currentApplication browsers size
				* (1 max: self currentApplication buses size)
				* self tableLineHeight)
]

{ #category : #height }
MiOverviewBrowser class >> busesTabHeight [
	^ self currentApplication buses size * self toolbarHeight
		+
			(self currentApplication buses size
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
	^ (self comment lines copyUpTo: '')
		fold: [ :s1 :s2 | s1 , Character cr asString , s2 ]
]

{ #category : #'world menu' }
MiOverviewBrowser class >> menuCommandOn: aBuilder [
	<worldMenu>
	(aBuilder item: #'Moose IDE Overview')
		order: 1 ;
		parent: #Moose ;
		action: [ self open ] ;
		help: self helpMessage
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
	| browsersMenu |
	browsersMenu := SpMenuPresenter new
		addAllFromPragma: 'miBrowsers' target: self.

	(self collectMenuItems: browsersMenu)
		do: [ :item | self replaceMenuItemAction: item ].
	^ browsersMenu
]

{ #category : #toolbar }
MiOverviewBrowser >> collectMenuItems: aMenuPresenter [
	| menuItems |
	aMenuPresenter ifNil: [ ^#() ].

	menuItems := OrderedCollection new.
	aMenuPresenter menuGroups
	do: [:menuGrp | 
		menuGrp menuItems do: [:anItem |
			menuItems add: anItem.
			menuItems addAll: (self collectMenuItems: anItem subMenu)]
	].
	^menuItems
		
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
MiOverviewBrowser >> initializeLayout [

	| tempLayout |
	tempLayout := SpBoxLayout newVertical
		add: (SpBoxLayout newHorizontal
			add: busesButton width: self class buttonWidth;
			add: browsersButton expand: false;
			add: chkOpenInPage expand: false;
			add: SpNullPresenter new expand: true;
			add: helpButton width: self class iconWidth)
		height: self class toolbarHeight;
		add: mainPresenter;
		yourself.
		
	self layout: tempLayout
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
	self initializeNotebook.
	self initializeLayout
]

{ #category : #initialization }
MiOverviewBrowser >> initializeToolbar [

	busesButton := self newButton
		iconName: #smallAdd;
		label: 'Add Bus';
		action: [ self openBusEditor ];
		yourself.
	
	browsersButton := self newMenuBar
		addItem: [ :item | 
			item
				icon: MooseIcons mooseIcon;
				name: 'Open new browser';
				subMenu: self browsersMenu ].

	chkOpenInPage := self newCheckBox 
		label: 'Open in page' ;
		labelOnRight ;
		yourself.
	
	helpButton := self newButton
		iconName: #help;
		help: self class comment;
		action: [ self showHelp ];
		yourself
]

{ #category : #initialization }
MiOverviewBrowser >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter initialExtent: 500 @ self class height
]

{ #category : #toolbar }
MiOverviewBrowser >> openBusEditor [

	self newPopover
		relativeTo: busesButton;
		presenter: (MiBusesPopup on: self);
		popup
]

{ #category : #presenters }
MiOverviewBrowser >> openedBrowsers [

	^ self application browsers asOrderedCollection collect: [ :browser | 
		  MiBrowserPresenter on: browser ]
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
	| browserClass pageName itemAction |
	itemAction := aMenuItem action.

	itemAction selector ifNil: [ 
		aMenuItem action: [ "empty action to avoid errors when selecting subMenu labels" ].
		^ self
	].

	browserClass := itemAction receiver outerContext receiver.
	pageName := aMenuItem name.
	aMenuItem action: [
		chkOpenInPage state
		ifTrue: [
			self addBrowser: browserClass asPage: pageName.
			mainPresenter selectPage: mainPresenter pages last ]
		ifFalse: [
			itemAction value ]
	]
]

{ #category : #toolbar }
MiOverviewBrowser >> showHelp [
	self newPopover
		relativeTo: helpButton;
		presenter: (MiHelpPopup on: self);
		popup
]

{ #category : #api }
MiOverviewBrowser >> updateBrowsersListItems [

	browsersListPresenter items: self openedBrowsers
]
