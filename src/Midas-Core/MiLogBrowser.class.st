"
A browser to show the content of the MiLogger.
Allows logs edition & removal.
Can propagate previous logs.

Follow:
Receives & propagates MooseObjects.

Highlght:
logs containing the received object
"
Class {
	#name : #MiLogBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'entryList',
		'toolbar'
	],
	#category : #'Midas-Core-Browser'
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
		action: [ self runMe ]
]

{ #category : #'world menu' }
MiLogBrowser class >> runMe [
	<script>
	^ self new
		openWithSpec;
		yourself

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
MiLogBrowser >> followAction [
	self updateList
]

{ #category : #initialization }
MiLogBrowser >> initializePresenters [
	super initializePresenters.
	"toolbar"
	toolbar := self newToolBar
		addItem:
			(SpToolBarButtonPresenter new
				label: 'Clean';
				help: 'Remove all the logger entries';
				action: [ self model clean.
					self updateList ];
				yourself).

	"list"
	entryList := self newList.
	entryList contextMenu: [ self rootCommandsGroup asMenuPresenter ].
	self model: self application logger.
	entryList items: self model logs.
	entryList display: [ :anElement | anElement entity mooseName ]
]

{ #category : #accessing }
MiLogBrowser >> logger [
	^ self application logger
]

{ #category : #initialization }
MiLogBrowser >> miSelectedItem [
	^ entryList selectedItems ifEmpty: [ super miSelectedItem ] ifNotEmpty: [ :list | "We can select only one entity" list anyOne entity ]
]

{ #category : #initialization }
MiLogBrowser >> miSelectedLogEntry [
	^ entryList selection selectedItem
]

{ #category : #initialization }
MiLogBrowser >> removeLog: aLog [
	self logger removeLog: aLog.
	self updateList
]

{ #category : #actions }
MiLogBrowser >> updateList [
	entryList updateList
]
