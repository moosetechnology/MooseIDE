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

{ #category : #specs }
MiLogBrowser class >> defaultSpec [

	^ super defaultSpec
		  add: #toolbar height: self toolbarHeight;
		  yourself
]

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
	^ (self on: self newModel)
		  openWithSpec;
		  followBuses: self currentApplication buses;
		  yourself
]

{ #category : #'as yet unclassified' }
MiLogBrowser class >> openOnBus: aBus [

	^ (self newApplication: self currentApplication)
		  openWithSpec;
		  followBus: aBus;
		  yourself
]

{ #category : #initialization }
MiLogBrowser class >> title [
	^ 'Logger'
]

{ #category : #testing }
MiLogBrowser >> canReceiveEntity: anObject [

	^ true
]

{ #category : #actions }
MiLogBrowser >> cleanAllLoggers [

	self logsList do: [ :presenter | presenter bus logger clean ].
	self update
]

{ #category : #buses }
MiLogBrowser >> followBuses: aCollectionOfBus [

	aCollectionOfBus do: [ :aBus | self followBus: aBus ]
]

{ #category : #actions }
MiLogBrowser >> followEntity: anEntity [

	self update
]

{ #category : #initialization }
MiLogBrowser >> initialize [

	logsLists := #(  ).
	super initialize.
	self propagateCommand doNotFreezeBrowser
]

{ #category : #initialization }
MiLogBrowser >> initializePresenters [

	toolbar := self newToolbar
		           addItemRight: (SpToolbarButtonPresenter new
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
MiLogBrowser >> unselectAll [

	self selectedItem: nil.
	logsLists do: [ :busLogsList | busLogsList unselectAll ]
]

{ #category : #actions }
MiLogBrowser >> update [

	self selectedItem: nil.
	self updateLogsList.
	super update
]

{ #category : #initialization }
MiLogBrowser >> updateLogsList [

	| boxLayout |
	logsLists := (self buses sorted: [ :bus | bus name ] ascending) 
		             collect: [ :bus | 
			             MiBusLogsList new
				             owner: self;
				             forBus: bus ].

	boxLayout := SpBoxLayout newVertical.
	logsLists do: [ :busLogsList | boxLayout add: busLogsList ].

	self layout: (self class defaultSpec
			 add: boxLayout;
			 yourself)
]
