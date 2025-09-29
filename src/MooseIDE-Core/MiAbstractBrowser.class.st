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
	#name : 'MiAbstractBrowser',
	#superclass : 'MiPresenter',
	#instVars : [
		'buses',
		'receivingMode',
		'specModel',
		'inspector'
	],
	#category : 'MooseIDE-Core-Browser',
	#package : 'MooseIDE-Core',
	#tag : 'Browser'
}

{ #category : 'accessing' }
MiAbstractBrowser class >> allBrowsers [

	^ self allSubclasses reject: #isAbstract
]

{ #category : 'menu' }
MiAbstractBrowser class >> allBrowsersMenuRoot: aRootMenu action: aBlock [

	(self allBrowsers sortAscending: #menuPriority) do: [ :browserClass |
		browserClass buildItemInMenu: aRootMenu action: aBlock ].

	^ aRootMenu
]

{ #category : 'keymaps' }
MiAbstractBrowser class >> browserKey [

	"Override with a character to be used after m (for Moose) to open your browser"

	^ nil
]

{ #category : 'menu' }
MiAbstractBrowser class >> buildItemInMenu: aMenuGroupPresenter action: aBlock [

	self isAbstract ifTrue: [ ^ self ].

	aMenuGroupPresenter addItem: [ :item |
		item
			name: self title;
			action: [ aBlock cull: self ];
			help: self helpMessage;
			icon: self menuIcon ]
]

{ #category : 'world menu' }
MiAbstractBrowser class >> buildMenuItemIn: aBuilder [

	"Method used in subclasses"

	^ (aBuilder item: self menuItem)
		  parent: self menuParent;
		  label: self menuLabel;
		  icon: self menuIcon;
		  help: self helpMessage;
		  order: self menuPriority;
		  action: [ self open ];
		  keyText: self keyText;
		  yourself
]

{ #category : 'world menu' }
MiAbstractBrowser class >> buildMenuItemIn: aBuilder action: aBlock [
	"Method used in subclasses"

	^ (aBuilder item: self menuItem)
		  parent: self menuParent;
		  label: self menuLabel;
		  icon: self menuIcon;
		  help: self helpMessage;
		  order: self menuPriority;
		  action: aBlock;
		  keyText: self keyText;
		  yourself
]

{ #category : 'world menu' }
MiAbstractBrowser class >> famixMenuRoot [

	^ #Famix
]

{ #category : 'world menu' }
MiAbstractBrowser class >> helpMessage [

	^ self comment ifNil: [ '' ] ifNotNil: [ :comment |
		  String streamContents: [ :s |
			  comment lineIndicesDo: [ :start :end :ignored |
				  start = (end + 1) ifTrue: [ "stop at empty line" ^ s contents ].
				  start = 1 ifFalse: [ s nextPut: Character cr ].
				  start to: end do: [ :i | s nextPut: (comment at: i) ] ] ] ]
]

{ #category : 'testing' }
MiAbstractBrowser class >> isAbstract [ 
	^ self == MiAbstractBrowser
]

{ #category : 'keymaps' }
MiAbstractBrowser class >> keyText [

	^ self browserKey ifNotNil: [ :aCharacter |
		  'M, {1}' format: { aCharacter asUppercase } ]
]

{ #category : 'world menu' }
MiAbstractBrowser class >> menuCodeToolsPriority [

	^ 20
]

{ #category : 'world menu' }
MiAbstractBrowser class >> menuCommandOn: aBuilder [
	"Library > Famix > Old browsers"

	<worldMenu>
	(aBuilder item: self oldBrowserMenuRoot)
		parent: self famixMenuRoot;
		icon: self menuIcon;
		order: self menuOldBrowsersPriority
]

{ #category : 'world menu' }
MiAbstractBrowser class >> menuIcon [

	^ self iconNamed: self menuIconName
]

{ #category : 'world menu' }
MiAbstractBrowser class >> menuIconName [

	"Override if needed"

	^ #blank
]

{ #category : 'world menu' }
MiAbstractBrowser class >> menuItem [

	self subclassResponsibility
]

{ #category : 'world menu' }
MiAbstractBrowser class >> menuLabel [

	"Override if necessary"

	^ self title
]

{ #category : 'world menu' }
MiAbstractBrowser class >> menuMainToolsPriority [

	^ 0
]

{ #category : 'world menu' }
MiAbstractBrowser class >> menuMetaToolsPriority [

	^ 40
]

{ #category : 'world menu' }
MiAbstractBrowser class >> menuOldBrowsersPriority [

	^ 200
]

{ #category : 'world menu' }
MiAbstractBrowser class >> menuParent [

	"Override if necessary"

	^ self mooseMenuRoot
]

{ #category : 'world menu' }
MiAbstractBrowser class >> menuPharoToolsPriority [

	^ 30
]

{ #category : 'world menu' }
MiAbstractBrowser class >> menuPriority [

	^ 100
]

{ #category : 'world menu' }
MiAbstractBrowser class >> menuVisualizationToolsPriority [

	^ 10
]

{ #category : 'menu' }
MiAbstractBrowser class >> miBrowsersMenuPresenter [

	^ self
		  allBrowsersMenuRoot: SpMenuPresenter new
		  action: [ :browserClass | browserClass open ]
]

{ #category : 'world menu' }
MiAbstractBrowser class >> mooseMenuRoot [

	^ #Moose
]

{ #category : 'instance creation' }
MiAbstractBrowser class >> new [

	^ self on: self newModel
]

{ #category : 'world menu' }
MiAbstractBrowser class >> newBrowser: aBrowserClass [

	aBrowserClass open
]

{ #category : 'instance creation' }
MiAbstractBrowser class >> newModel [
	"Override to return a model (in the MVC sense) for your browser"

	^ nil
]

{ #category : 'world menu' }
MiAbstractBrowser class >> oldBrowserMenuRoot [

	^ #'Old browsers'
]

{ #category : 'instance creation' }
MiAbstractBrowser class >> open [

	^ (self on: self newModel)
		  open;
		  followBus: self currentApplication defaultBus;
		  yourself
]

{ #category : 'keymaps' }
MiAbstractBrowser class >> openKeyMap [

	^ self browserKey ifNotNil: [
		  KMKeymap shortcut: self shortcut action: [ self open ] ]
]

{ #category : 'instance creation' }
MiAbstractBrowser class >> openOn: anEntity [

	^ (self on: self newModel)
		  open;
		  receiveEntity: anEntity;
		  beFrozen;
		  followBus: self currentApplication defaultBus;
		  yourself
]

{ #category : 'specs' }
MiAbstractBrowser class >> preferredExtent [

	^ 500 @ 400
]

{ #category : 'keymaps' }
MiAbstractBrowser class >> shortcut [

	^ self browserKey ifNotNil: [ :aCharacter |
		  $m shift meta , aCharacter shift meta ]
]

{ #category : 'testing' }
MiAbstractBrowser class >> shouldBuildToolbar [

	^ true
]

{ #category : 'accessing' }
MiAbstractBrowser class >> taskbarIcon [
	^MooseIcons mooseIcon

]

{ #category : 'actions' }
MiAbstractBrowser >> beFrozen [

	self receivingMode: MiFreezeMode.
	self window updateReceivingModeButtons
]

{ #category : 'window control' }
MiAbstractBrowser >> browserClosed [

	buses do: [ :bus | bus unregisterBrowser: self ]
]

{ #category : 'window control' }
MiAbstractBrowser >> browserCollapsed [

	self beFrozen
]

{ #category : 'window control' }
MiAbstractBrowser >> browserExpanded [
	"should we 'unfroze' ?"
]

{ #category : 'accessing' }
MiAbstractBrowser >> buses [

	^ buses ifNil: [ Set new ]
]

{ #category : 'testing' }
MiAbstractBrowser >> canEditBuses [

	^ true
]

{ #category : 'testing' }
MiAbstractBrowser >> canFollow [

	^ true
]

{ #category : 'testing' }
MiAbstractBrowser >> canFollowEntity: anObject [

	"whether the browser accepts to deal with anObject"

	self subclassResponsibility
]

{ #category : 'testing' }
MiAbstractBrowser >> canHighlight [

	"Override to retrun true if you want to give your browser a highlight behavior. 
	This behavior should be define by overriding #highlightEntity:"

	^ false
]

{ #category : 'testing' }
MiAbstractBrowser >> canPropagate [

	| entity |
	"Ideally we should use miSelectedItemToPropagate but this would make the models browser really slow since it would copy the whole model and reject the stubs each time I'm called. So we do not care about checking the stubs here by calling #miSelectedItem.."
	entity := self miSelectedItem.
	^ (entity isCollection and: [ entity isNotEmpty ]) or: [
		  entity isMooseObject and: [ entity isCollection not ] ]
]

{ #category : 'testing' }
MiAbstractBrowser >> canTagEntities [

	^ true
]

{ #category : 'private - for tests' }
MiAbstractBrowser >> closeSettings [
	"to close the settings window when testing
	Should not be used otherwise"

	self hasSettings ifTrue: [ self specModel settings window close ]
]

{ #category : 'layout' }
MiAbstractBrowser >> defaultLayout [

	^ SpBoxLayout newVertical
		  add: #mainPresenter;
		  yourself
]

{ #category : 'buses' }
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

{ #category : 'actions' }
MiAbstractBrowser >> followEntity: anEntity [

	anEntity ifNotNil: [
			self withWindowDo: [ :window |
				window title: (self windowTitleFor: anEntity) ] ]
]

{ #category : 'actions' }
MiAbstractBrowser >> freezeDuring: aBlock [

	| previousMode |
	previousMode := receivingMode.

	receivingMode := MiFreezeMode.

	aBlock ensure: [ receivingMode := previousMode ]
]

{ #category : 'testing' }
MiAbstractBrowser >> hasSettings [

	^ specModel hasSettings
]

{ #category : 'testing' }
MiAbstractBrowser >> hasVisualization [
	
	^ false
]

{ #category : 'highlighting' }
MiAbstractBrowser >> highlightEntity: anEntity [

	"Override to add behavior on highlight. 
	Don't forget to override #canHighlight to return true"

	
]

{ #category : 'initialization' }
MiAbstractBrowser >> initialize [

	super initialize.
	self receivingMode: MiFollowMode.
	buses := Set new
]

{ #category : 'initialization' }
MiAbstractBrowser >> initializeWindow: aMiWindowPresenter [

	super initializeWindow: aMiWindowPresenter.

	self class shouldBuildToolbar ifTrue: [
		aMiWindowPresenter buildToolbar ].

	aMiWindowPresenter
		setContextBindingKeys;
		whenClosedDo: [ self browserClosed ];
		withAdapterPerformOrDefer: [ :anAdapter |
			self registerToAdapterEvents: anAdapter ]
]

{ #category : 'private - for tests' }
MiAbstractBrowser >> inspector [

	^ inspector ifNil: [ inspector := MiInspectorBrowser ]
]

{ #category : 'testing' }
MiAbstractBrowser >> isMiBrowser [
	^ true
]

{ #category : 'accessing' }
MiAbstractBrowser >> miSelectedItem [

	^ (MiNoSelectedElementToPropagateException browser: self) signal
]

{ #category : 'accessing' }
MiAbstractBrowser >> miSelectedItemToPropagate [
	"Hook to be able to add some filters in the model browser."

	^ self miSelectedItem
]

{ #category : 'accessing' }
MiAbstractBrowser >> model [

	self
		deprecated: 'This is a getter. Lets name it correctly.'
		transformWith: '`@receiver model' -> '`@receiver specModel'.
	^ self specModel
]

{ #category : 'accessing' }
MiAbstractBrowser >> model: anObject [

	self
		deprecated: 'This is a getter. Lets name it correctly.'
		transformWith:
		'`@receiver model: `@arg' -> '`@receiver specModel: `@arg'.
	self specModel: anObject
]

{ #category : 'actions' }
MiAbstractBrowser >> openSettings [

	^ specModel openSettings
]

{ #category : 'private - accessing' }
MiAbstractBrowser >> receiveEntity: anEntity [

	"Entry point to receiving an entity used by MiApplication.
	This method is called when an entity has been propagated on a bus I listen.
	See MiBus>>#globallySelect:"

	receivingMode browser: self actOnEntity: anEntity.
	self updateToolbar
]

{ #category : 'accessing' }
MiAbstractBrowser >> receivingMode [

	^ receivingMode
]

{ #category : 'accessing' }
MiAbstractBrowser >> receivingMode: aReceivingMode [

	receivingMode := aReceivingMode
]

{ #category : 'window control' }
MiAbstractBrowser >> registerToAdapterEvents: anAdapter [
	"spec does not give access to window collapsing/expanding events
	 This is a hack to get them on Morph backend"

	anAdapter widget announcer
		when: WindowCollapsed
		do: [ self browserCollapsed ]
		for: self.

	anAdapter widget announcer
		when: WindowExpanded
		do: [ self browserExpanded ]
		for: self
]

{ #category : 'accessing' }
MiAbstractBrowser >> selectedTag [

	^ self specModel
		  ifNil: [ nil ]
		  ifNotNil: [ :model | model selectedTag ]
]

{ #category : 'accessing' }
MiAbstractBrowser >> selectedTag: aTag [

	self specModel
		ifNil: [ nil ]
		ifNotNil: [ :model | model selectedTag: aTag ].
	self updateToolbar
]

{ #category : 'initialization' }
MiAbstractBrowser >> setModelBeforeInitialization: aBrowserModel [
	aBrowserModel ifNil: [ ^self ].

	specModel := aBrowserModel.
	specModel browser: self
]

{ #category : 'actions' }
MiAbstractBrowser >> settings [

	self
		deprecated: 'This is not a getter so it should not appear like one'
		transformWith: '`@receiver settings' -> '`@receiver openSettings'.

	self openSettings
]

{ #category : 'accessing' }
MiAbstractBrowser >> specModel [

	^ specModel
]

{ #category : 'accessing' }
MiAbstractBrowser >> specModel: anObject [

	specModel := anObject
]

{ #category : 'accessing' }
MiAbstractBrowser >> tagList [

	^ self specModel
		  ifNil: [ #(  ) ]
		  ifNotNil: [ :model | model tagList ]
]

{ #category : 'accessing' }
MiAbstractBrowser >> tagName [
	^self selectedTag
		ifNil: [ '' ]
		ifNotNil: [ :tag | tag name ]
]

{ #category : 'actions' }
MiAbstractBrowser >> tagSelectedEntities [

	self specModel ifNotNil: [ :model | model tagSelectedEntities ]
]

{ #category : 'buses' }
MiAbstractBrowser >> unfollowBus: aBus [

	(self buses includes: aBus) ifFalse: [ ^ self ].
	self buses remove: aBus.
	aBus unregisterBrowser: self.
	self window ifNotNil: [ :window | window updateBusButton ]
]

{ #category : 'actions' }
MiAbstractBrowser >> updateToolbar [

	self window ifNotNil: [ :window | window updateToolbar. ]
]

{ #category : 'accessing' }
MiAbstractBrowser >> windowTitle [

	^ self class title
]

{ #category : 'accessing' }
MiAbstractBrowser >> windowTitleFor: anEntity [

	^ String streamContents: [ :stream |
			  stream
				  << self class title;
				  << ' on '.
			  anEntity displayStringOn: stream ]
]
