"
Shows the content of the MiLogger.
Proposes edition & removal of logs.
Can propagate previous logs.

- Follow:
Accepts MooseObjects.

- Highlght:
<TODO> Logs containing the received object.

- Propagate:
MooseObjects.
"
Class {
	#name : #MiLogBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'entryList',
		'toolbar'
	],
	#category : #'Midas-Core-Logger'
}

{ #category : #'world menu' }
MiLogBrowser class >> buildCommandsGroupWith: presenterInstance forRoot: rootCommandGroup [
	super buildCommandsGroupWith: presenterInstance forRoot: rootCommandGroup.
	rootCommandGroup register: (MiLoggerRemoveEntryCommand forSpecContext: presenterInstance)
]

{ #category : #'world menu' }
MiLogBrowser class >> defaultSpec [
	^ super defaultSpec
		add: #toolbar withConstraints: [ :constraints | constraints height: self toolbarHeight ]; 
		add: #entryList;
		yourself
]

{ #category : #'world menu' }
MiLogBrowser class >> menuCommandOn: aBuilder [
	<worldMenu>
	(aBuilder item: #Logger)
		parent: self toolbarName;
		label: self title;
		order: 1.0;
		help: self helpMessage;
		action: [ self runMe ]
]

{ #category : #'world menu' }
MiLogBrowser class >> runMe [
	<script>
	^ super runMe
]

{ #category : #'instance creation' }
MiLogBrowser class >> runMeFollowing: aBus [
	^ (self on: aBus logger)
		followBus: aBus;
		openWithSpec;
		selectEntity: aBus logger mostRecentEntity
]

{ #category : #initialization }
MiLogBrowser class >> title [
	^ 'Logger'
]

{ #category : #testing }
MiLogBrowser >> accept: anObject [
	^ true
]

{ #category : #actions }
MiLogBrowser >> cleanLogger [
	self logger clean.
	entryList updateList
]

{ #category : #actions }
MiLogBrowser >> followAction [
	entryList updateList
]

{ #category : #actions }
MiLogBrowser >> followBus: aBus [
	entryList items: aBus logger logs.
	super followBus: aBus
]

{ #category : #initialization }
MiLogBrowser >> initializeEntryList [
	entryList := self newList.
	entryList contextMenu: [ self rootCommandsGroup asMenuPresenter ].
	entryList display: [ :anElement | anElement entity mooseName ]
]

{ #category : #initialization }
MiLogBrowser >> initializePresenters [
	super initializePresenters.
	self initializeToolBar.
	self initializeEntryList
]

{ #category : #initialization }
MiLogBrowser >> initializeToolBar [
	toolbar := self newToolBar
		addItem:
			(SpToolBarButtonPresenter new
				label: 'Clean';
				help: 'Remove all the logger entries';
				action: [ self cleanLogger ];
				yourself)
]

{ #category : #accessing }
MiLogBrowser >> logger [
	^ self bus logger
]

{ #category : #accessing }
MiLogBrowser >> miSelectedItem [
	^ entryList selectedItems
		ifEmpty: [ super miSelectedItem ]
		ifNotEmpty: [ :list | "We can select only one entity" list anyOne entity ]
]

{ #category : #accessing }
MiLogBrowser >> miSelectedLogEntry [
	^ entryList selection selectedItem
]

{ #category : #actions }
MiLogBrowser >> removeLog: aLog [
	self logger removeLog: aLog.
	entryList updateList
]
