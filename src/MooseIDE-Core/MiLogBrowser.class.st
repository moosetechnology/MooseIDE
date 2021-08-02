"
Shows logs of the entities that are propagated.
Proposes edition & removal of logs.
Can propagate previous logs.

- Follow: Accepts MooseObjects.
- Highlght: <TODO> Logs containing the received object.
- Propagate: MooseObjects
"
Class {
	#name : #MiLogBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'toolbar',
		'selectedItem',
		'logsLists'
	],
	#category : #'MooseIDE-Core-Logger'
}

{ #category : #'world menu' }
MiLogBrowser class >> menuCommandOn: aBuilder [

	<worldMenu>
	<miBrowsers>
	(aBuilder item: #Logger)
		parent: #Moose;
		label: self title;
		order: 4;
		help: self helpMessage;
		action: [ self open ];
		withSeparatorAfter
]

{ #category : #'world menu' }
MiLogBrowser class >> open [

	<script>
	^ super open
		  followBuses: self currentApplication buses;
		  yourself
]

{ #category : #'as yet unclassified' }
MiLogBrowser class >> openOnBus: aBus [

	^ (self newApplication: self currentApplication)
		  followBus: aBus;
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
MiLogBrowser >> followBuses: aCollectionOfBus [

	aCollectionOfBus do: [ :aBus | self followBus: aBus ]
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
