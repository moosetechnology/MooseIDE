"
I handle the toolbar and the buses for the MiBrowsers.
I am an empty shell containing a MiBrowser

"
Class {
	#name : #MiAtomicWorkspace,
	#superclass : #MiPresenter,
	#instVars : [
		'buses',
		'receivingMode',
		'browserContainer'
	],
	#category : #'MooseIDE-Core-Browser'
}

{ #category : #specs }
MiAtomicWorkspace class >> actionsCommandGroupFor: presenter [
	^ CmCommandGroup forSpec
		  name: 'Actions';
		  register:
			  (MiPropagateCommand forSpecContext: presenter)
				  beDisplayedOnRightSide;
		  register:
			  (MiInspectCommand forSpecContext: presenter)
				  beDisplayedOnRightSide
]

{ #category : #specs }
MiAtomicWorkspace class >> defaultSpec [

	^SpBoxLayout newVertical
		add: #browserContainer ;
		yourself
]

{ #category : #'world menu' }
MiAtomicWorkspace class >> helpMessage [
	^ (self comment lines copyUpTo: '')
		fold: [ :s1 :s2 | s1 , Character cr asString , s2 ]
]

{ #category : #testing }
MiAtomicWorkspace class >> isAbstract [ 
	^ self == MiAbstractBrowser
]

{ #category : #'world menu' }
MiAtomicWorkspace class >> menuCommandOn: aBuilder [

	<worldMenu>
	(aBuilder item: self midasBrowserMenuLabel)
		order: 8;
		parent: #Moose;
		icon: MooseIcons mooseIcon
]

{ #category : #'world menu' }
MiAtomicWorkspace class >> menuMetaCommandOn: aBuilder [
	"need to be a separate method because of #miBrowsers pragma"
	<worldMenu>
	<miBrowsers>
	(aBuilder item: self metaBrowsersMenuLabel)
		order: 100;
		parent: (self midasBrowserMenuLabel);
		icon: MooseIcons mooseIcon
]

{ #category : #'world menu' }
MiAtomicWorkspace class >> metaBrowsersMenuLabel [
	^ #Meta
]

{ #category : #'world menu' }
MiAtomicWorkspace class >> midasBrowserMenuLabel [
	^ #'Specialized Browsers'
]

{ #category : #'instance creation' }
MiAtomicWorkspace class >> newModel [
	"Override to return a model for your browser"

	^ nil
]

{ #category : #'instance creation' }
MiAtomicWorkspace class >> open [

	^ (self on: self newModel)
		  openWithSpec;
		  followBus: self currentApplication defaultBus;
		  yourself
]

{ #category : #specs }
MiAtomicWorkspace class >> windowSize [
	^ 500 @ 400
]

{ #category : #accessing }
MiAtomicWorkspace >> buses [
	^ buses
]

{ #category : #testing }
MiAtomicWorkspace >> canEditBuses [

	^ true
]

{ #category : #testing }
MiAtomicWorkspace >> canFollow [

	^self containedBrowser canFollow
]

{ #category : #testing }
MiAtomicWorkspace >> canHighlight [

	^self containedBrowser canHighlight
]

{ #category : #testing }
MiAtomicWorkspace >> canPropagate [
	^self containedBrowser canPropagate
]

{ #category : #testing }
MiAtomicWorkspace >> canReceiveEntity: anObject [
	^self containedBrowser canReceiveEntity: anObject 
]

{ #category : #accessing }
MiAtomicWorkspace >> containedBrowser [

	^ browserContainer installedPresenter
		ifNil: [ | presenter |
			presenter := MiNullBrowser new.
			browserContainer install: presenter.
			presenter
		]
]

{ #category : #accessing }
MiAtomicWorkspace >> containedBrowser: aMiBrowser [

	browserContainer install: aMiBrowser.
	self updateToolbar.
	self resetLayout
]

{ #category : #buses }
MiAtomicWorkspace >> followBus: aBus [

	(self buses includes: aBus) ifTrue: [ ^ self ].
	self buses add: aBus.
	aBus registerBrowser: self.
	self window ifNotNil: [ :window | window updateBusButton ].
	self selectEntity: aBus logger mostRecentEntity
]

{ #category : #actions }
MiAtomicWorkspace >> followEntity: anEntity [

	^self containedBrowser followEntity: anEntity 
]

{ #category : #actions }
MiAtomicWorkspace >> freezeDuring: aBlock [

	| previousMode |
	previousMode := receivingMode.

	receivingMode := MiFreezeMode.

	aBlock ensure: [ receivingMode := previousMode ]
]

{ #category : #actions }
MiAtomicWorkspace >> highlightEntity: anEntity [
	self containedBrowser highlightEntity: anEntity 
]

{ #category : #testing }
MiAtomicWorkspace >> ifAutonomous: aBlock [
	^self containedBrowser ifAutonomous: aBlock 
]

{ #category : #initialization }
MiAtomicWorkspace >> initialize [

	super initialize.
	self setDefaultReceivingMode.
	buses := Set new
]

{ #category : #initialization }
MiAtomicWorkspace >> initializeLayout [

	self layout: self class defaultSpec
]

{ #category : #initialization }
MiAtomicWorkspace >> initializePresenters [
	super initializePresenters.
	browserContainer := self instantiate: SpSingleDropInContainer.
	self initializeLayout
]

{ #category : #initialization }
MiAtomicWorkspace >> initializeWindow: aMiWindowPresenter [

	super initializeWindow: aMiWindowPresenter.

	aMiWindowPresenter buildToolbar.

	aMiWindowPresenter whenClosedDo: [ 
		self buses do: [ :bus | bus unregisterBrowser: self ] ].

	aMiWindowPresenter initialExtent: self class windowSize
]

{ #category : #testing }
MiAtomicWorkspace >> isMiBrowser [
	^ true
]

{ #category : #accessing }
MiAtomicWorkspace >> miSelectedItem [

	^self containedBrowser miSelectedItem 
]

{ #category : #accessing }
MiAtomicWorkspace >> model [
	^self containedBrowser model
]

{ #category : #accessing }
MiAtomicWorkspace >> model: anObject [
	self containedBrowser model: anObject
]

{ #category : #testing }
MiAtomicWorkspace >> needUpdate: anEntity [

	^self containedBrowser needUpdate: anEntity
]

{ #category : #accessing }
MiAtomicWorkspace >> receivingMode [

	^ receivingMode
]

{ #category : #accessing }
MiAtomicWorkspace >> receivingMode: aReceivingMode [

	receivingMode := aReceivingMode
]

{ #category : #initialization }
MiAtomicWorkspace >> resetLayout [

	^self initializeLayout 
]

{ #category : #'private - accessing' }
MiAtomicWorkspace >> selectEntity: anEntity [

	"I am used by the Mi Application. You should use #globallySelect: anEntity that will transmit the message to me and the other browsers"

	receivingMode browser: self containedBrowser actOnEntity: anEntity.
	self updateToolbar
]

{ #category : #initialization }
MiAtomicWorkspace >> setDefaultReceivingMode [

	self receivingMode: MiFollowMode
]

{ #category : #'accessing - model' }
MiAtomicWorkspace >> setModelBeforeInitialization: aModel [
	
]

{ #category : #actions }
MiAtomicWorkspace >> showHelp [

	| help |
	(help := self newPopover)
		relativeTo: self window toolbar;
		bePositionRight;
		presenter: (MiHelpPopup owner: help on: self containedBrowser);
		popup
]

{ #category : #buses }
MiAtomicWorkspace >> unfollowBus: aBus [

	(self buses includes: aBus) ifFalse: [ ^ self ].
	self buses remove: aBus.
	aBus unregisterBrowser: self.
	self window ifNotNil: [ :window | window updateBusButton ]
]

{ #category : #actions }
MiAtomicWorkspace >> updateToolbar [

	self window ifNotNil: [ :window | window updateToolbar ]
]
