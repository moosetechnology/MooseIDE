"
I handle the toolbar and the buses for the MiBrowsers.
I am an empty shell containing a MiBrowser

"
Class {
	#name : #MiAtomicWorkspace,
	#superclass : #MiAbstractWorkspace,
	#instVars : [
		'browserContainer'
	],
	#category : #'MooseIDE-Core-workspace'
}

{ #category : #'instance creation' }
MiAtomicWorkspace class >> open [
	<script: 'MiAtomicWorkspace open'>
	^super open
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
	self updateWindow
]

{ #category : #actions }
MiAtomicWorkspace >> dragBrowser [
	| dragButton |
	self flag: 'Unfortunately, this is specific to Morphic. should find a way to be more generic'.
	dragButton := MiMorphicDragMeAdapter new
		adapt: (SpDragMe new passenger: self containedBrowser) ;
		yourself.
	dragButton startDragging.

]

{ #category : #actions }
MiAtomicWorkspace >> followEntity: anEntity [

	^self containedBrowser followEntity: anEntity 
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
MiAtomicWorkspace >> initializePresenters [
	super initializePresenters.
	browserContainer := self newContainer.
	self initializeLayout.
]

{ #category : #initialization }
MiAtomicWorkspace >> initializeWindow: aMiWindowPresenter [

	super initializeWindow: aMiWindowPresenter.

	aMiWindowPresenter initialExtent: self containedBrowser desiredWindowSize.
	aMiWindowPresenter title: self containedBrowser windowTitle.

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

{ #category : #removing }
MiAtomicWorkspace >> noteThatWidgetHasBeenReinstalled: aMiBrowser [
	self containedBrowser = aMiBrowser
		ifFalse: [ ^self ].

	self window close
]

{ #category : #'private - accessing' }
MiAtomicWorkspace >> selectEntity: anEntity [

	"I am used by the Mi Application. You should use #globallySelect: anEntity that will transmit the message to me and the other browsers"

	receivingMode browser: self containedBrowser actOnEntity: anEntity.
	self updateToolbar
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

{ #category : #'private - updating' }
MiAtomicWorkspace >> updateTitle [
	self hasWindow
		ifTrue: [ self window title: self containedBrowser windowTitle]
	
]

{ #category : #'private - updating' }
MiAtomicWorkspace >> updateWindowSize [
		self hasWindow
		ifTrue: [ self window resize: self containedBrowser desiredWindowSize ]
]
