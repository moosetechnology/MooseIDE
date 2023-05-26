"
I am a bus log browser. I display logs of all buses, each one in a notebook.

Accepted entities: Does not apply.
"
Class {
	#name : #MiLogsBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'mainPresenter'
	],
	#category : #'MooseIDE-Core-Logger'
}

{ #category : #menu }
MiLogsBrowser class >> addItemOrSubMenuToMiBrowsersMenu: aRootMenu defaultSubMenu: aSubMenu [

	self addToMiBrowsersMenu: aRootMenu
]

{ #category : #'world menu' }
MiLogsBrowser class >> menuCommandOn: aBuilder [

	<worldMenu>
	^ self buildMenuItemIn: aBuilder
]

{ #category : #'world menu' }
MiLogsBrowser class >> menuItem [

	^ #Logger
]

{ #category : #'world menu' }
MiLogsBrowser class >> menuPriority [

	^ self menuMetaToolsPriority + 1
]

{ #category : #'instance creation' }
MiLogsBrowser class >> open [

	<script>
	^ (self on: self newModel)
		  followBuses: self currentApplication buses;
		  open;
		  updateToolbars;
		  yourself
]

{ #category : #specs }
MiLogsBrowser class >> title [

	^ 'Logger'
]

{ #category : #testing }
MiLogsBrowser >> canFollowEntity: anObject [

	"Subpresenters are MiBrowsers. They are responsible for entities reception"

	^ false
]

{ #category : #testing }
MiLogsBrowser >> canPropagate [

	^ self miSelectedItem isMooseObject and: [ 
		  self miSelectedItem asMooseGroup isNotEmpty or: [ 
			  self miSelectedItem isMooseModel ] ]
]

{ #category : #testing }
MiLogsBrowser >> canTagEntities [

	^false
]

{ #category : #buses }
MiLogsBrowser >> followBus: aBus [

	  | busPage |
	  super followBus: aBus.

	  mainPresenter addPage: (busPage := SpNotebookPage
			              title: aBus name
			              provider: [ 
			              MiBusLogBrowser forBus: aBus application: application ]).

	  self window ifNotNil: [ mainPresenter selectPage: busPage ].
	  busPage activePresenter ifNotNil: #updateToolbars
]

{ #category : #buses }
MiLogsBrowser >> followBuses: aCollectionOfBus [

	(aCollectionOfBus sorted: [ :aBus | aBus name ] ascending) do: [ 
		:aBus | self followBus: aBus ]
]

{ #category : #actions }
MiLogsBrowser >> followEntity: anEntity [

	"Subpresenters are MiBrowsers. They are responsible for entities reception"

	
]

{ #category : #initialization }
MiLogsBrowser >> initializePresenters [

	self layout: (SpBoxLayout newTopToBottom
			 add: (mainPresenter := self newNotebook);
			 yourself).

	mainPresenter whenSelectedPageChangedDo: [ :selectedPage | 
		selectedPage activePresenter ifNotNil: [ :activePresenter | 
			activePresenter updateToolbars ] ]
]

{ #category : #initialization }
MiLogsBrowser >> initializeWindow: aMiWindowPresenter [

	super initializeWindow: aMiWindowPresenter.

	aMiWindowPresenter whenClosedDo: [ 
		mainPresenter pages do: [ :page | 
			page activePresenter ifNotNil: [ :presenter | 
				presenter buses do: [ :bus | bus unregisterBrowser: presenter ] ] ] ]
]

{ #category : #accessing }
MiLogsBrowser >> miSelectedItem [

	^ mainPresenter selectedPage ifNotNil: [ :page | 
		  page activePresenter miSelectedItem ]
]

{ #category : #initialization }
MiLogsBrowser >> updateToolbars [

	self updateToolbar.
	mainPresenter selectedPage activePresenter ifNotNil: [ 
		:activePresenter | activePresenter updateLocalToolbar ]
]
