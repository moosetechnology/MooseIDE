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
	<script: 'MiAtomicWorkspace open'>
	^super open
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
	self install: aMiBrowser inContainer: browserContainer
]

{ #category : #accessing }
MiAtomicWorkspace >> containedBrowsers [
	^{ self containedBrowser }
]

{ #category : #'private - updating' }
MiAtomicWorkspace >> desiredWindowSize [
	^self containedBrowser desiredWindowSize
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
MiAtomicWorkspace >> ifAutonomous: aBlock [
	^self containedBrowser ifAutonomous: aBlock 
]

{ #category : #initialization }
MiAtomicWorkspace >> initialExtent [
	^self containedBrowser desiredWindowSize
]

{ #category : #initialization }
MiAtomicWorkspace >> initializePresenters [
	super initializePresenters.
	browserContainer := self newContainer.
	self initializeLayout.
]

{ #category : #accessing }
MiAtomicWorkspace >> model [
	^self containedBrowser model
]

{ #category : #accessing }
MiAtomicWorkspace >> model: anObject [
	self containedBrowser model: anObject
]

{ #category : #removing }
MiAtomicWorkspace >> noteThatWidgetHasBeenReinstalled: aMiBrowser [
	self containedBrowser = aMiBrowser
		ifFalse: [ ^self ].

	self window close
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
	^self containedBrowser windowTitle
]
