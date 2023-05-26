"
I am superclass for all browsers in Midas.
I provide a toolBar with:
	- Radio buttons to choose a reception mode: Follow, Freeze and Highlight.
	- Buttons to inspect and propagate the current selection.
	- A help button that shows the class comment for each browser. 

Concrete browsers should use my instance variable #model (MVC model, not Moose model).
It is created by the default #open method on class side. 
The model should inherit from MiAbstractModel and override:
Instance side:
	- #canFollowEntity: | which entities the browser can receive
	- #followEntity | what to do with the received entity in Follow mode
	- #highlightEntity | what to do with the received entity in Highlight mode
	- #miSelectedItem | entity (or entities) to propagate
Class side:	
	- #title | The browser window title
	- #menuCommandOn: | To be integrated into Midas Browsers menu
Spec2 methods: 
	#initializePresenters, #defaultLayout, ...

Please comment your browser as follow: 
*************************************************
A few lines describing the browser purpose.

- Follow:
Entities accepted and associated behavior.

- Highlight:
Highlight behavior.

- Propagate:
Propagated entities.
*************************************************
"
Class {
	#name : #MiAbstractBrowser,
	#superclass : #MiPresenter,
	#instVars : [
		'buses',
		'receivingMode',
		'specModel',
		'inspector'
	],
	#category : #'MooseIDE-Core-Browser'
}

{ #category : #menu }
MiAbstractBrowser class >> addItemOrSubMenuToMiBrowsersMenu: aRootMenu defaultSubMenu: aSubMenu [

	self addToMiBrowsersMenu: aSubMenu
]

{ #category : #menu }
MiAbstractBrowser class >> addToMiBrowsersMenu: aMenuPresenter [

	"Override with an empty method if you don't want your browser in Moose menu"

	self buildItemInMenu: aMenuPresenter
]

{ #category : #menu }
MiAbstractBrowser class >> buildItemInMenu: aMenuGroupPresenter [

	"Override with an empty method if you don't want your browser in Moose menu"

	aMenuGroupPresenter addItem: [ :item | 
		item
			name: self title;
			action: [ self open ];
			help: self helpMessage;
			icon: self menuIcon ]
]

{ #category : #'world menu' }
MiAbstractBrowser class >> buildMenuItemIn: aBuilder [

	"Method used in subclasses"

	^ (aBuilder item: self menuItem)
		  parent: self menuParent;
		  label: self menuLabel;
		  icon: self menuIcon;
		  help: self helpMessage;
		  order: self menuPriority;
		  action: [ self open ];
		  yourself
]

{ #category : #layout }
MiAbstractBrowser class >> defaultLayout [

	^ SpBoxLayout newVertical
]

{ #category : #menu }
MiAbstractBrowser class >> defaultSubMenuLabel [

	^ 'Specialized Browsers'
]

{ #category : #'menu organization' }
MiAbstractBrowser class >> famixMenuRoot [

	^ #Famix
]

{ #category : #'world menu' }
MiAbstractBrowser class >> helpMessage [

	^ (self comment lines copyUpTo: '') fold: [ :s1 :s2 | 
		  s1 , Character cr asString , s2 ]
]

{ #category : #testing }
MiAbstractBrowser class >> isAbstract [ 
	^ self == MiAbstractBrowser
]

{ #category : #testing }
MiAbstractBrowser class >> isModelImporter [
	^false
]

{ #category : #'menu organization' }
MiAbstractBrowser class >> menuCodeToolsPriority [

	^ 20
]

{ #category : #'world menu' }
MiAbstractBrowser class >> menuCommandOn: aBuilder [

	<worldMenu>

	"Library > Famix > Old browsers"
	(aBuilder item: self oldBrowserMenuRoot)
		parent: self famixMenuRoot;
		icon: self menuIcon;
		order: self oldBrowserMenuPriority.

	"Library > Famix > Old browsers > Meta"
	(aBuilder item: self oldMetaBrowsersMenuRoot)
		parent: self oldBrowserMenuRoot;
		icon: self menuIcon;
		order: self oldMetaBrowsersMenuPriority
]

{ #category : #'world menu' }
MiAbstractBrowser class >> menuIcon [

	^ self iconNamed: self menuIconName
]

{ #category : #'world menu' }
MiAbstractBrowser class >> menuIconName [

	"Override if needed"

	^ #blank
]

{ #category : #'world menu' }
MiAbstractBrowser class >> menuItem [

	self subclassResponsibility
]

{ #category : #'world menu' }
MiAbstractBrowser class >> menuLabel [

	"Override if necessary"

	^ self title
]

{ #category : #'menu organization' }
MiAbstractBrowser class >> menuMainToolsPriority [

	^ 0
]

{ #category : #'menu organization' }
MiAbstractBrowser class >> menuMetaToolsPriority [

	^ 40
]

{ #category : #'world menu' }
MiAbstractBrowser class >> menuParent [

	"Override if necessary"

	^ self mooseMenuRoot
]

{ #category : #'menu organization' }
MiAbstractBrowser class >> menuPharoToolsPriority [

	^ 30
]

{ #category : #'world menu' }
MiAbstractBrowser class >> menuPriority [

	^ 100
]

{ #category : #'menu organization' }
MiAbstractBrowser class >> menuVisualizationToolsPriority [

	^ 10
]

{ #category : #menu }
MiAbstractBrowser class >> miBrowsersMenuPresenter [

	| rootMenu defaultSubMenu |
	rootMenu := SpMenuPresenter new.
	defaultSubMenu := SpMenuPresenter new.

	(self subclasses sortAscending: [ :browserClass | 
		 browserClass menuPriority ]) do: [ :browserClass | 
		browserClass
			addItemOrSubMenuToMiBrowsersMenu: rootMenu
			defaultSubMenu: defaultSubMenu ].

	rootMenu addItem: [ :item | 
		item
			name: self defaultSubMenuLabel;
			subMenu: defaultSubMenu ].

	^ rootMenu
]

{ #category : #'menu organization' }
MiAbstractBrowser class >> mooseMenuRoot [

	^ #Moose
]

{ #category : #'instance creation' }
MiAbstractBrowser class >> newModel [
	"Override to return a model (in the MVC sense) for your browser"

	^ nil
]

{ #category : #'menu organization' }
MiAbstractBrowser class >> oldBrowserMenuPriority [

	^ 30
]

{ #category : #'menu organization' }
MiAbstractBrowser class >> oldBrowserMenuRoot [

	^ #'Old browsers'
]

{ #category : #'menu organization' }
MiAbstractBrowser class >> oldMetaBrowsersMenuPriority [

	^ 100
]

{ #category : #'menu organization' }
MiAbstractBrowser class >> oldMetaBrowsersMenuRoot [

	^ #Meta
]

{ #category : #'instance creation' }
MiAbstractBrowser class >> open [

	^ (self on: self newModel)
		  open;
		  followBus: self currentApplication defaultBus;
		  yourself
]

{ #category : #'instance creation' }
MiAbstractBrowser class >> openOn: anEntity [

	^ (self on: self newModel)
		  open;
		  receiveEntity: anEntity;
		  beFrozen;
		  followBus: self currentApplication defaultBus;
		  yourself
]

{ #category : #accessing }
MiAbstractBrowser class >> taskbarIcon [
	^MooseIcons mooseIcon

]

{ #category : #specs }
MiAbstractBrowser class >> windowSize [

	^ 500 @ 400
]

{ #category : #testing }
MiAbstractBrowser >> acceptsDropFileExtension: aString [
	^false
]

{ #category : #actions }
MiAbstractBrowser >> beFrozen [

	self receivingMode: MiFreezeMode.
	self window updateReceivingModeButtons
]

{ #category : #'window control' }
MiAbstractBrowser >> browserClosed [
	buses do: [ :bus | bus unregisterBrowser: self ]
]

{ #category : #accessing }
MiAbstractBrowser >> buses [
	^ buses
]

{ #category : #testing }
MiAbstractBrowser >> canEditBuses [

	^ true
]

{ #category : #testing }
MiAbstractBrowser >> canFollow [

	^ true
]

{ #category : #testing }
MiAbstractBrowser >> canFollowEntity: anObject [

	"whether the browser accepts to deal with anObject"

	self subclassResponsibility
]

{ #category : #testing }
MiAbstractBrowser >> canHighlight [

	"Override to retrun true if you want to give your browser a highlight behavior. 
	This behavior should be define by overriding #highlightEntity:"

	^ false
]

{ #category : #testing }
MiAbstractBrowser >> canPropagate [

	| entity |

	entity := self miSelectedItem.
	^ entity isMooseObject and: [ 
		  entity asMooseGroup isNotEmpty or: [ entity isMooseModel ] ]
]

{ #category : #testing }
MiAbstractBrowser >> canTagEntities [

	^ true
]

{ #category : #'private - for tests' }
MiAbstractBrowser >> closeSettings [
	"to close the settings window when testing
	Should not be used otherwise"

	self hasSettings 
	ifTrue: [ self model settings window close]
]

{ #category : #buses }
MiAbstractBrowser >> followBus: aBus [

	  (self buses includes: aBus) ifTrue: [ 
		  application defaultBus: aBus.
		  ^ self ].

	  self buses add: aBus.
	  aBus registerBrowser: self.
	  self window ifNotNil: [ :window | window updateBusButton ].
	  self receiveEntity: aBus logger mostRecentEntity.
	  application defaultBus: aBus
]

{ #category : #actions }
MiAbstractBrowser >> followEntity: anEntity [

	^ self subclassResponsibility
]

{ #category : #actions }
MiAbstractBrowser >> freezeDuring: aBlock [

	| previousMode |
	previousMode := receivingMode.

	receivingMode := MiFreezeMode.

	aBlock ensure: [ receivingMode := previousMode ]
]

{ #category : #testing }
MiAbstractBrowser >> hasSettings [

	^false
]

{ #category : #actions }
MiAbstractBrowser >> highlightEntity: anEntity [

	"Override to add behavior on highlight. 
	Don't forget to override #canHighlight to return true"

	
]

{ #category : #testing }
MiAbstractBrowser >> ifAutonomous: aBlock [
	
	self owner isNotNil and: [ 
		self owner isWindowPresenter ifTrue: aBlock ]
]

{ #category : #initialization }
MiAbstractBrowser >> initialize [

	super initialize.
	self setDefaultReceivingMode.
	inspector := MiInspectorBrowser.
	buses := Set new
]

{ #category : #initialization }
MiAbstractBrowser >> initializeWindow: aMiWindowPresenter [

	super initializeWindow: aMiWindowPresenter.

	aMiWindowPresenter buildToolbar.

	aMiWindowPresenter whenClosedDo: [ 
		self browserClosed ].

	aMiWindowPresenter initialExtent: self class windowSize
]

{ #category : #'private - for tests' }
MiAbstractBrowser >> inspector [

	^ inspector
]

{ #category : #accessing }
MiAbstractBrowser >> inspector: anObject [

	inspector := anObject
]

{ #category : #testing }
MiAbstractBrowser >> isMiBrowser [
	^ true
]

{ #category : #testing }
MiAbstractBrowser >> isModelImporter [
	^self class isModelImporter
]

{ #category : #'as yet unclassified' }
MiAbstractBrowser >> miInspect [

	self inspector inspect: self miSelectedItem forBuses: buses
]

{ #category : #accessing }
MiAbstractBrowser >> miSelectedItem [

	^ (MiNoSelectedElementToPropagateException browser: self) signal
]

{ #category : #accessing }
MiAbstractBrowser >> model [
	^ specModel
]

{ #category : #accessing }
MiAbstractBrowser >> model: anObject [
	specModel := anObject
]

{ #category : #testing }
MiAbstractBrowser >> needUpdate: anEntity [

	^ anEntity ~= specModel selected
]

{ #category : #'private - accessing' }
MiAbstractBrowser >> receiveEntity: anEntity [

	"I am used by the Mi Application. You should use #globallySelect: anEntity that will transmit the message to me and the other browsers"

	receivingMode browser: self actOnEntity: anEntity.
	self updateToolbar
]

{ #category : #accessing }
MiAbstractBrowser >> receivingMode [

	^ receivingMode
]

{ #category : #accessing }
MiAbstractBrowser >> receivingMode: aReceivingMode [

	receivingMode := aReceivingMode
]

{ #category : #accessing }
MiAbstractBrowser >> selectedTag [
	^self model
		ifNil: [ nil ]
		ifNotNil: [ :model | model selectedTag]
]

{ #category : #accessing }
MiAbstractBrowser >> selectedTag: aTag [
	^self model
		ifNil: [ nil ]
		ifNotNil: [ :model | model selectedTag: aTag]
]

{ #category : #initialization }
MiAbstractBrowser >> setDefaultReceivingMode [

	self receivingMode: MiFollowMode
]

{ #category : #initialization }
MiAbstractBrowser >> setModelBeforeInitialization: aBrowserModel [
	aBrowserModel ifNil: [ ^self ].

	specModel := aBrowserModel.
	specModel browser: self
]

{ #category : #actions }
MiAbstractBrowser >> settings [
	"not used if #hasSettings is false"

	self subclassResponsibility 
]

{ #category : #actions }
MiAbstractBrowser >> showHelp [

	| help |
	(help := self newPopover)
		"the first right item in the toolbar is the Help buttton"
		relativeTo: self window toolbar rightItems first;
		bePositionLeft;
		presenter: (MiHelpPopup owner: help on: self);
		popup

]

{ #category : #actions }
MiAbstractBrowser >> tagEntitiesSelected [

	^self model
		ifNotNil: [ :model | model tagEntitiesSelected ]
]

{ #category : #accessing }
MiAbstractBrowser >> tagIcon [

	^application iconProvider iconForTag: self selectedTag  
]

{ #category : #accessing }
MiAbstractBrowser >> tagList [

	^self model
		ifNil: [ #() ]
		ifNotNil: [ :model | model tagList ]
]

{ #category : #accessing }
MiAbstractBrowser >> tagName [
	^self selectedTag
		ifNil: [ '' ]
		ifNotNil: [ :tag | tag name ]
]

{ #category : #buses }
MiAbstractBrowser >> unfollowBus: aBus [

	(self buses includes: aBus) ifFalse: [ ^ self ].
	self buses remove: aBus.
	aBus unregisterBrowser: self.
	self window ifNotNil: [ :window | window updateBusButton ]
]

{ #category : #actions }
MiAbstractBrowser >> updateToolbar [

	self window ifNotNil: [ :window | window updateToolbar ]
]
