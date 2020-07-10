"
Shows logs of the entities that are propagated.
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
		'toolbar',
		'selectedItem',
		'logsLists'
	],
	#category : #'Midas-Core-Logger'
}

{ #category : #'world menu' }
MiLogBrowser class >> defaultSpec [
	^ super defaultSpec
		"add: #toolbar
			withConstraints: [ :constraints | constraints height: self toolbarHeight ];"
		add: #logsLists;
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
	| browser |
	browser := self new
		initializeBuses: self currentApplication buses;
		openWithSpec;
		yourself.
	^ browser
]

{ #category : #'world menu' }
MiLogBrowser class >> runMeFollowing: aBus [
	| browser |
	browser := self new
		initializeBuses: {aBus};
		openWithSpec;
		yourself.
	^ browser
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
MiLogBrowser >> cleanAllLoggers [
	self logsList presenters
		do: [ :presenter | presenter bus logger clean ].
	self update
]

{ #category : #actions }
MiLogBrowser >> followAction [
	self update
]

{ #category : #buses }
MiLogBrowser >> followBus: aBus [
	super followBus: aBus.
	self update
]

{ #category : #buses }
MiLogBrowser >> initializeBuses: someBuses [
	buses := Set new.
	someBuses do: [ :bus | super followBus: bus ]
]

{ #category : #initialization }
MiLogBrowser >> initializeLogsList [
	logsLists := self newNullPresenter
]

{ #category : #initialization }
MiLogBrowser >> initializePresenters [
	super initializePresenters.
	"self initializeToolBar."
	self initializeLogsList
]

{ #category : #initialization }
MiLogBrowser >> initializeToolBar [
	toolbar := self newToolBar
		addItem:
			(SpToolBarToggleButtonPresenter new
				label: 'Follow new buses';
				icon: (self iconNamed: #glamorousRedo);
				help: 'Each time you create a bus, this browser will follow it';
				action: [ self flag: 'Do we want that ?'.
					self setFollowNewBuses ];
				yourself);
		addItem:
			(SpToolBarButtonPresenter new
				label: 'Clear all';
				icon: (self theme iconNamed: #smallDelete);
				help: 'Remove all loggers entries';
				action: [ self cleanAllLoggers ];
				yourself);
		yourself
]

{ #category : #accessing }
MiLogBrowser >> miSelectedItem [
	^ selectedItem
]

{ #category : #accessing }
MiLogBrowser >> selectedItem: anEntity [
	selectedItem := anEntity
]

{ #category : #buses }
MiLogBrowser >> unfollowBus: aBus [
	super unfollowBus: aBus.
	self update
]

{ #category : #actions }
MiLogBrowser >> update [
	self updateLogsList.
	super update
]

{ #category : #initialization }
MiLogBrowser >> updateLogsList [
	logsLists := SpDynamicPresentersListBuilder new
		modelObjects: self buses asOrderedCollection;
		presenter: MiBusLogsList
			configuredAs: [ :presenter :bus | 
			presenter
				owner: self;
				forBus: bus ];
		layoutBuilder: (SpDynamicTopToBottomRowsLayout rows: 1);
		build
]
