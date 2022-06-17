"
Workspaces are windows that can contain MiAbstractBrowsers.
The workspace handles the buses and the toolbar for the browsers
"
Class {
	#name : #MiAbstractWorkspace,
	#superclass : #MiPresenter,
	#instVars : [
		'buses',
		'receivingMode',
		'privateBus'
	],
	#category : #'MooseIDE-Core-Workspace'
}

{ #category : #layout }
MiAbstractWorkspace class >> defaultLayout [

	^ self subclassResponsibility
]

{ #category : #testing }
MiAbstractWorkspace class >> isAbstract [

	^ self == MiAbstractWorkspace
]

{ #category : #'instance creation' }
MiAbstractWorkspace class >> open [

	<script: 'MiAtomicWorkspace open'>
	^ self new
		  open;
		  followBus: self currentApplication defaultBus;
		  yourself
]

{ #category : #icons }
MiAbstractWorkspace class >> taskbarIcon [

	^ MooseIcons mooseIcon
]

{ #category : #buses }
MiAbstractWorkspace >> buses [

	^ buses
]

{ #category : #testing }
MiAbstractWorkspace >> canBeDragged [

	self flag:
		'This could be removed once all browsers use the new infrastructure and can all be dragged'.

	^ true
]

{ #category : #testing }
MiAbstractWorkspace >> canEditBuses [

	^ true
]

{ #category : #testing }
MiAbstractWorkspace >> canFollow [

	^ self containedBrowsers anySatisfy: [ :browser | browser canFollow ]
]

{ #category : #testing }
MiAbstractWorkspace >> canFollowEntity: anObject [

	^ self containedBrowsers anySatisfy: [ :browser | 
		  browser canFollowEntity: anObject ]
]

{ #category : #testing }
MiAbstractWorkspace >> canHighlight [

	^ self containedBrowsers anySatisfy: [ :browser | 
		  browser canHighlight ]
]

{ #category : #testing }
MiAbstractWorkspace >> canPropagate [

	^ self containedBrowsers anySatisfy: [ :browser | 
		  browser canPropagate ]
]

{ #category : #accessing }
MiAbstractWorkspace >> containedBrowsers [
	self subclassResponsibility 
]

{ #category : #buses }
MiAbstractWorkspace >> followBus: aBus [

	(self buses includes: aBus) ifTrue: [ 
		application defaultBus: aBus.
		^ self ].

	self buses add: aBus.
	aBus registerBrowser: self.

	self withWindowDo: [ :window | window updateBusButton ].

	self receiveEntity: aBus logger mostRecentEntity
]

{ #category : #actions }
MiAbstractWorkspace >> followEntity: anEntity [

	^ self privateBus globallySelect: anEntity
]

{ #category : #actions }
MiAbstractWorkspace >> freezeDuring: aBlock [

	| previousMode |
	previousMode := receivingMode.

	receivingMode := MiFreezeMode.

	aBlock ensure: [ receivingMode := previousMode ]
]

{ #category : #testing }
MiAbstractWorkspace >> hasSettings [

	^ false
]

{ #category : #actions }
MiAbstractWorkspace >> highlightEntity: anEntity [

	"In HighlightMode, we propagate the entity to the containedBrowsers that are in the same mode and will act accordingly"

	self followEntity: anEntity
]

{ #category : #initialization }
MiAbstractWorkspace >> initialize [

	super initialize.
	self setDefaultReceivingMode.
	
	buses := Set new.
	self initializePrivateBus
	
]

{ #category : #initialization }
MiAbstractWorkspace >> initializePrivateBus [

	privateBus := MiPrivateBus new name: 'workspace bus'.
	privateBus registerBrowser: self
]

{ #category : #initialization }
MiAbstractWorkspace >> initializeWindow: aMiWindowPresenter [

	super initializeWindow: aMiWindowPresenter.

	aMiWindowPresenter buildToolbar.

	aMiWindowPresenter whenClosedDo: [ 
		self containedBrowsers do: [ :browser | browser browserClosed ].
		self buses do: [ :bus | bus unregisterBrowser: self ] ].

	aMiWindowPresenter initialExtent: self windowSize
]

{ #category : #actions }
MiAbstractWorkspace >> install: aMiBrowser inContainer: aMiDropInContainer [

	"Remove previous containedBrowser from privateBus."
	aMiDropInContainer installedPresenter ifNotNil: [ :previousBrowser | 
		previousBrowser unfollowPrivateBus ].

	"Remove aMiBrowser from its former privateBus."
	aMiBrowser unfollowPrivateBus.

	"Puts aMiBrowser on receiver's privateBus (need to set receiving mode for this)."
	aMiBrowser receivingMode: self receivingMode.
	aMiBrowser followPrivateBus: self privateBus.

	"Puts aMiBrowser in aMiDropInContainer."
	aMiDropInContainer install: aMiBrowser.

	"Redisplay window"
	self updateWindow
]

{ #category : #testing }
MiAbstractWorkspace >> isMiBrowser [

	^ true
]

{ #category : #accessing }
MiAbstractWorkspace >> miSelectedItem [

	^ privateBus mostRecentEntity ifNil: [ 
		  (MiNoSelectedElementToPropagateException browser: self) signal.
		  nil ]
]

{ #category : #testing }
MiAbstractWorkspace >> needUpdate: anEntity [

	^ self containedBrowsers anySatisfy: [ :browser | 
		  browser needUpdate: anEntity ]
]

{ #category : #'instance creation' }
MiAbstractWorkspace >> newContainer [

	^ self instantiate: MiSingleDropInContainer
]

{ #category : #buses }
MiAbstractWorkspace >> privateBus [

	^ privateBus
]

{ #category : #accessing }
MiAbstractWorkspace >> receiveEntity: anEntity [

	"I am used by the Mi Application. You should use #globallySelect: anEntity that will transmit the message to me and the other browsers"

	receivingMode browser: self actOnEntity: anEntity.
	self updateWindowToolbar
]

{ #category : #buses }
MiAbstractWorkspace >> receiveFromPrivateBus: anEntity [

	"Propagating on privateBus has no effect on workspace:
	the privateBus takes care of propagating to contained browser(s)"

	
]

{ #category : #accessing }
MiAbstractWorkspace >> receivingMode [

	^ receivingMode
]

{ #category : #accessing }
MiAbstractWorkspace >> receivingMode: aReceivingMode [

	"for Follow and Highlight, we need to update containedBrowsers.
	For Frozen, it is handled by the workspace, so it makes no difference"

	receivingMode := aReceivingMode.
	self containedBrowsers do: [ :containedBrowser | 
		containedBrowser receivingMode: aReceivingMode ]
]

{ #category : #initialization }
MiAbstractWorkspace >> setDefaultReceivingMode [

	self receivingMode: MiFollowMode
]

{ #category : #buses }
MiAbstractWorkspace >> unfollowBus: aBus [

	(self buses includes: aBus) ifFalse: [ ^ self ].

	self buses remove: aBus.
	aBus unregisterBrowser: self.

	self withWindowDo: [ :window | window updateBusButton ]
]

{ #category : #'private - updating' }
MiAbstractWorkspace >> updateReceivingModeButtons [

	self withWindowDo: [ :window | window updateReceivingModeButtons ]
]

{ #category : #'private - updating' }
MiAbstractWorkspace >> updateWindow [

	self updateWindowToolbar
]

{ #category : #'private - updating' }
MiAbstractWorkspace >> updateWindowToolbar [

	self withWindowDo: [ :window | window updateToolbar ]
]

{ #category : #'private - updating' }
MiAbstractWorkspace >> windowSize [

	self subclassResponsibility
]
