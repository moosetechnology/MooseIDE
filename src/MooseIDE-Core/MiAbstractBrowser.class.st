"
I am superclass for all browsers in Midas.
I provide a toolBar with:
	- Radio buttons to choose a reception mode: Follow, Freeze and Highlight.
	- Buttons to inspect and propagate the current selection.
	- A help button that shows the class comment for each browser. 

Concrete browsers can use my instance variable #model (it can be initialized with #initializeModel).
They should override:
Instance side:
	- #accept: | which entities the browser can receive
	- #followAction | what to do with the received entity in Follow mode
	- #highlightAction | what to do with the received entity in Highlight mode
	- #miSelectedItem | entity (or entities) to propagate
Class side:	
	- #title | The browser window title
	- #menuCommandOn: | To be integrated into Midas Browsers menu
Spec2 methods: 
	#initializePresenters, #defaultSpec, ...

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
		'model',
		'buttonPropagate',
		'buttonInspect',
		'buses',
		'receivingMode',
		'toolbarCommandGroup'
	],
	#category : #'MooseIDE-Core-Browser'
}

{ #category : #specs }
MiAbstractBrowser class >> buildCommandsGroupWith: presenter forRoot: rootCommandGroup [

	rootCommandGroup
		register:
			(MiReceivingModeCommand asCommandGroupForSpecContext: presenter);
		register: (MiEditBusCommand forSpecContext: presenter);
		register:
			(MiHelpCommand forSpecContext: presenter) beDisplayedOnRightSide;
		register: (CmCommandGroup forSpec
				 name: 'Actions';
				 register:
					 (MiPropagateCommand forSpecContext: presenter)
						 beDisplayedOnRightSide;
				 register:
					 (MiInspectCommand forSpecContext: presenter)
						 beDisplayedOnRightSide)
]

{ #category : #specs }
MiAbstractBrowser class >> defaultSpec [

	^ SpBoxLayout newVertical
]

{ #category : #'world menu' }
MiAbstractBrowser class >> helpMessage [
	^ (self comment lines copyUpTo: '')
		fold: [ :s1 :s2 | s1 , Character cr asString , s2 ]
]

{ #category : #testing }
MiAbstractBrowser class >> isAbstract [ 
	^ self == MiAbstractBrowser
]

{ #category : #'world menu' }
MiAbstractBrowser class >> menuCommandOn: aBuilder [

	<worldMenu>
	(aBuilder item: self midasBrowserMenuLabel)
		order: 8;
		parent: #Moose;
		icon: MooseIcons mooseIcon
]

{ #category : #'world menu' }
MiAbstractBrowser class >> menuMetaCommandOn: aBuilder [
	"need to be a separate method because of #miBrowsers pragma"
	<worldMenu>
	<miBrowsers>
	(aBuilder item: self metaBrowsersMenuLabel)
		order: 100;
		parent: (self midasBrowserMenuLabel);
		icon: MooseIcons mooseIcon
]

{ #category : #'world menu' }
MiAbstractBrowser class >> metaBrowsersMenuLabel [
	^ #Meta
]

{ #category : #'world menu' }
MiAbstractBrowser class >> midasBrowserMenuLabel [
	^ #'Specialized Browsers'
]

{ #category : #'instance creation' }
MiAbstractBrowser class >> newModel [
	"Override to return a model for your browser"

	^ nil
]

{ #category : #'instance creation' }
MiAbstractBrowser class >> open [

	^ (self on: self newModel)
		  openWithSpec;
		  followBus: self currentApplication defaultBus;
		  yourself
]

{ #category : #specs }
MiAbstractBrowser class >> windowSize [
	^ 500 @ 400
]

{ #category : #accessing }
MiAbstractBrowser >> buses [
	^ buses
]

{ #category : #testing }
MiAbstractBrowser >> canFollow [

	^ true
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
MiAbstractBrowser >> canReceiveEntity: anObject [

	"whether the browser accepts to deal with anObject"

	self subclassResponsibility
]

{ #category : #buses }
MiAbstractBrowser >> followBus: aBus [

	(self buses includes: aBus) ifTrue: [ ^ self ].
	self buses add: aBus.
	aBus registerBrowser: self.
	self updateBusButton.
	self selectEntity: aBus logger mostRecentEntity. 
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

{ #category : #actions }
MiAbstractBrowser >> highlightEntity: anEntity [

	"Override to add behavior on highlight. 
	Don't forget to override #canHighlight to return true"

	
]

{ #category : #initialization }
MiAbstractBrowser >> initialize [

	super initialize.
	self setDefaultReceivingMode.
	buses := Set new
]

{ #category : #initialization }
MiAbstractBrowser >> initializeWindow: aMiWindowPresenter [

	super initializeWindow: aMiWindowPresenter.
	aMiWindowPresenter toolbar:
		(self newToolbar fillWith: self toolbarCommandGroup).
	aMiWindowPresenter whenOpenedDo: [ self updateToolbar ].
	aMiWindowPresenter whenClosedDo: [ 
		self buses do: [ :bus | bus unregisterBrowser: self ] ]
]

{ #category : #testing }
MiAbstractBrowser >> isMiBrowser [
	^ true
]

{ #category : #accessing }
MiAbstractBrowser >> miSelectedItem [

	^ (MiNoSelectedElementToPropagateException browser: self) signal
]

{ #category : #accessing }
MiAbstractBrowser >> model [
	^ model
]

{ #category : #accessing }
MiAbstractBrowser >> model: anObject [
	model := anObject
]

{ #category : #testing }
MiAbstractBrowser >> needUpdate: anEntity [

	^ anEntity ~= model selected
]

{ #category : #'private - accessing' }
MiAbstractBrowser >> propagateCommand [

	^ ((self toolbarCommandGroup commandOrGroupNamed: 'Actions') 
		   commandOrGroupNamed: 'Propagate') decoratedCommand
]

{ #category : #accessing }
MiAbstractBrowser >> receivingMode: aReceivingMode [

	receivingMode := aReceivingMode
]

{ #category : #'private - accessing' }
MiAbstractBrowser >> selectEntity: anEntity [

	"I am used by the Mi Application. You should use #globallySelect: anEntity that will transmit the message to me and the other browsers"

	receivingMode browser: self actOnEntity: anEntity.
	self updateToolbar
]

{ #category : #initialization }
MiAbstractBrowser >> setDefaultReceivingMode [

	self receivingMode: MiFollowMode
]

{ #category : #'accessing model' }
MiAbstractBrowser >> setModelBeforeInitialization: aModel [
	model := aModel
]

{ #category : #actions }
MiAbstractBrowser >> showHelp [

	| help |
	(help := self newPopover)
		relativeTo: self window toolbar;
		bePositionRight;
		presenter: (MiHelpPopup owner: help on: self);
		popup
]

{ #category : #initialization }
MiAbstractBrowser >> toolbarCommandGroup [

	^ toolbarCommandGroup ifNil: [ toolbarCommandGroup := self rootCommandsGroup ]
]

{ #category : #buses }
MiAbstractBrowser >> unfollowBus: aBus [

	(self buses includes: aBus) ifFalse: [ ^ self ].
	self buses remove: aBus.
	aBus unregisterBrowser: self.
	self updateBusButton
]

{ #category : #buses }
MiAbstractBrowser >> updateBusButton [

	| busEditCommand |
	busEditCommand := self toolbarCommandGroup commandOrGroupNamed:
		                  'Buses'.
	busEditCommand presenter ifNil: [ ^ self ].
	busEditCommand presenter
		label: busEditCommand decoratedCommand label;
		help: busEditCommand decoratedCommand help
]

{ #category : #actions }
MiAbstractBrowser >> updateReceivingModeButtons [

	(self toolbarCommandGroup commandOrGroupNamed: 'Receiving Mode')
		commands do: [ :cmd | cmd updateIconForMode: receivingMode ]
]

{ #category : #actions }
MiAbstractBrowser >> updateToolbar [

	self toolbarCommandGroup allCommands do: [ :cmd | 
		cmd updateEnableStatus ].
	(self toolbarCommandGroup commandOrGroupNamed: 'Receiving Mode')
		commands do: [ :cmd | 
		cmd canBeExecuted ifFalse: [ 
			cmd presenter icon: (cmd icon lighter: 0.4) ] ]
]
