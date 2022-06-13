"
I handle the toolbar and the buses for the MiBrowsers.
I am an empty shell containing a MiBrowser therefore I should not be created by myself, but rather created on a regular MiBrowser

"
Class {
	#name : #MiAtomicWorkspace,
	#superclass : #MiAbstractWorkspace,
	#instVars : [
		'browserContainer'
	],
	#category : #'MooseIDE-Core-Workspace'
}

{ #category : #'instance creation' }
MiAtomicWorkspace class >> open [

	<script>
	^ super open
]

{ #category : #accessing }
MiAtomicWorkspace >> containedBrowser [

	^ browserContainer installedPresenter ifNil: [ 
		  | presenter |
		  presenter := MiNullBrowser new.
		  browserContainer install: presenter.
		  presenter ]
]

{ #category : #accessing }
MiAtomicWorkspace >> containedBrowser: aMiBrowser [

	self install: aMiBrowser inContainer: browserContainer
]

{ #category : #accessing }
MiAtomicWorkspace >> containedBrowsers [

	^ { self containedBrowser }
]

{ #category : #layout }
MiAtomicWorkspace >> defaultLayout [

	^ SpBoxLayout newVertical
		  add: #browserContainer;
		  yourself
]

{ #category : #actions }
MiAtomicWorkspace >> dragBrowser [

	| dragButton |
	self flag:
		'Unfortunately, this is specific to Morphic. should find a way to be more generic'.
	dragButton := MiMorphicDragMeAdapter new
		              adapt:
			              (MiDragMePresenter new passenger:
					               self containedBrowser);
		              yourself.
	dragButton startDragging
]

{ #category : #testing }
MiAtomicWorkspace >> hasSettings [

	^ self containedBrowser hasSettings
]

{ #category : #testing }
MiAtomicWorkspace >> ifAutonomous: aBlock [

	^ self containedBrowser ifAutonomous: aBlock
]

{ #category : #initialization }
MiAtomicWorkspace >> initializePresenters [

	super initializePresenters.
	browserContainer := self newContainer
]

{ #category : #actions }
MiAtomicWorkspace >> install: aMiBrowser inContainer: aMiDropInContainer [

	super install: aMiBrowser inContainer: aMiDropInContainer.
	aMiBrowser sendEntitiesToPrivateBus
]

{ #category : #accessing }
MiAtomicWorkspace >> model [

	^ self containedBrowser model
]

{ #category : #accessing }
MiAtomicWorkspace >> model: anObject [

	self containedBrowser model: anObject
]

{ #category : #removing }
MiAtomicWorkspace >> noteThatWidgetHasBeenReinstalled: aMiBrowser [

	self containedBrowser = aMiBrowser ifFalse: [ ^ self ].

	self window close
]

{ #category : #buses }
MiAtomicWorkspace >> receiveFromPrivateBus: anEntity [

	self updateWindow
]

{ #category : #'private - updating' }
MiAtomicWorkspace >> resetLayout [

	self layout: self defaultLayout
]

{ #category : #accessing }
MiAtomicWorkspace >> settings [

	^ self containedBrowser settings
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

{ #category : #initialization }
MiAtomicWorkspace >> title [

	^ self containedBrowser windowTitle
]

{ #category : #'private - updating' }
MiAtomicWorkspace >> updateWindow [

	super updateWindow.

	self updateWindowTitle.
	self updateWindowSize.
	self resetLayout
]

{ #category : #'private - updating' }
MiAtomicWorkspace >> updateWindowSize [

	self withWindowDo: [ :window | window resize: self windowSize ]
]

{ #category : #'private - updating' }
MiAtomicWorkspace >> updateWindowTitle [

	self withWindowDo: [ :window | window title: self title ]
]

{ #category : #'private - updating' }
MiAtomicWorkspace >> windowSize [

	^ self containedBrowser windowSize
]
