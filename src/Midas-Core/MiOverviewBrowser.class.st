"
Shows an overview of the current Midas state:
	- All buses
	- All opened browsers.
Centralizes bus and browser creation and managment.

Offers two tabs that present differently the same information:
	- Buses tab uses the buses as roots.
	- Browsers tab uses the browsers as roots.
"
Class {
	#name : #MiOverviewBrowser,
	#superclass : #MiPresenter,
	#instVars : [
		'mainPresenter',
		'busesButton',
		'browsersButton',
		'helpButton',
		'browsersPage',
		'busesPage'
	],
	#category : #'Midas-Core-Overview'
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

{ #category : #specs }
MiOverviewBrowser class >> defaultSpec [
	^ SpBoxLayout newVertical
		add:
			(SpBoxLayout newHorizontal
				add: #busesButton width: self buttonWidth;
				add: #browsersButton;
				add: SpNullPresenter new;
				add: #helpButton width: self iconWidth)
			height: self toolbarHeight;
		add: #mainPresenter;
		yourself
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
	(aBuilder item: #'Midas Overview')
		order: 0;
		parent: #Moose;
		withSeparatorAfter;
		action: [ self runMe ];
		help: self helpMessage
]

{ #category : #specs }
MiOverviewBrowser class >> runMe [
	<script>
	self new openWithSpec
]

{ #category : #specs }
MiOverviewBrowser class >> title [
	^ 'Midas Overview'
]

{ #category : #presenters }
MiOverviewBrowser >> browsersList [
	^ [ self newComponentList
		propagateNaturalHeight: true;
		items:
			(self application browsers asOrderedCollection
				collect: [ :browser | MiBrowserPresenter on: browser ]);
		whenSelectionChangedDo: [ :selection | selection selectedItem highlightWindow ] ]
]

{ #category : #toolbar }
MiOverviewBrowser >> browsersMenu [
	| browsersMenu |
	browsersMenu := SpMenuPresenter new
		addAllFromPragma: 'miBrowsers'
		target: self.

	"This empty action avoids an error when clicking on subMenu label"
	(browsersMenu menuGroups flatCollect: #menuItems)
		do: [ :item | item action selector ifNil: [ item action: [  ] ] ].
	^ browsersMenu
]

{ #category : #presenters }
MiOverviewBrowser >> browsersPage [
	^browsersPage
		ifNil: [ browsersPage := self pageNamed: 'Browsers' presenter: self browsersList ]
]

{ #category : #presenters }
MiOverviewBrowser >> busesList [
	^ [ self newComponentList
		propagateNaturalHeight: true;
		items: (self application buses collect: [ :bus | MiBusPresenter on: bus ]) ]
]

{ #category : #presenters }
MiOverviewBrowser >> busesPage [
	^busesPage
		ifNil: [ busesPage := self pageNamed: 'Buses' presenter: self busesList ]
]

{ #category : #initialization }
MiOverviewBrowser >> initializeMainPresenter [
	mainPresenter := self newNotebook
		addPage: self browsersPage;
		addPage: self busesPage;
		yourself
]

{ #category : #initialization }
MiOverviewBrowser >> initializePresenters [
	super initializePresenters.
	self initializeToolbar.
	self initializeMainPresenter
]

{ #category : #toolbar }
MiOverviewBrowser >> initializeToolbar [
	busesButton := self newButton
		iconName: #smallAdd;
		label: 'Add Bus';
		action: [ self modifyBuses ];
		yourself.
	browsersButton := self newMenuBar
		addItem: [ :item | 
			item
				icon: MooseIcons mooseIcon;
				name: 'Open new browser';
				subMenu: self browsersMenu ].
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
MiOverviewBrowser >> modifyBuses [
	self newPopover
		relativeTo: busesButton;
		presenter: (MiBusesPopup on: self);
		popup
]

{ #category : #presenters }
MiOverviewBrowser >> pageNamed: aName presenter: aComponentList [
	^ self newNotebookPage
		title: aName;
		presenterProvider: aComponentList;
		yourself
]

{ #category : #toolbar }
MiOverviewBrowser >> showHelp [
	self newPopover
		relativeTo: helpButton;
		presenter: (MiHelpPopup on: self);
		popup
]
