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
MiLogBrowser class >> menuCommandOn: aBuilder [
	<worldMenu>
	<miBrowsers>
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

{ #category : #initialization }
MiLogBrowser >> initializeActionButtons [
	buttonPropagate := ((MiPropagateCommand forContext: self)
		doNotFreezeBrowser;
		asSpecCommand) asButtonPresenter.
	buttonInspect := (MiInspectCommand forSpecContext: self)
		name: '';
		iconName: #smallInspectIt;
		asButtonPresenter
]

{ #category : #buses }
MiLogBrowser >> initializeBuses: someBuses [
	buses := Set new.
	someBuses do: [ :bus | super followBus: bus ]
]

{ #category : #initialization }
MiLogBrowser >> initializeToolbar [

	toolbar := self newToolbar
		           addItem: (SpToolbarButtonPresenter new
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

	logsLists := SpBoxLayout newVertical.

	self buses do: [ :bus | 
		logsLists add: (MiBusLogsList new
				 owner: self;
				 forBus: bus) ].

	self layout: (self class defaultSpec
			 add: logsLists;
			 yourself)
]
