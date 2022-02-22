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
	#category : #'MooseIDE-Core-workspace'
}

{ #category : #specs }
MiAbstractWorkspace class >> actionsCommandGroupFor: presenter [
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
MiAbstractWorkspace class >> defaultSpec [

	^SpBoxLayout newVertical
		add: #browserContainer ;
		yourself
]

{ #category : #testing }
MiAbstractWorkspace class >> isAbstract [ 
	^ self == MiAbstractWorkspace
]

{ #category : #'instance creation' }
MiAbstractWorkspace class >> newModel [ 
	^nil
]

{ #category : #'instance creation' }
MiAbstractWorkspace class >> open [
	<script: 'MiAtomicWorkspace open'>
	^ (self on: self newModel)
		  openWithSpec;
		  followBus: self currentApplication defaultBus;
		  yourself
]

{ #category : #icons }
MiAbstractWorkspace class >> taskbarIcon [
	^MooseIcons mooseIcon
]

{ #category : #specs }
MiAbstractWorkspace class >> windowSize [
	^ 500 @ 400
]

{ #category : #buses }
MiAbstractWorkspace >> buses [
	^ buses
]

{ #category : #testing }
MiAbstractWorkspace >> canBeDragged [
	"This could be removed once all browsers use the new infrastructure and can all be dragged"
	^true
]

{ #category : #testing }
MiAbstractWorkspace >> canEditBuses [

	^ true
]

{ #category : #testing }
MiAbstractWorkspace >> canFollow [
	^self containedBrowsers anySatisfy: [ :browser | browser canFollow ]
]

{ #category : #testing }
MiAbstractWorkspace >> canHighlight [
	^self containedBrowsers anySatisfy: [ :browser | browser canHighlight ]
]

{ #category : #testing }
MiAbstractWorkspace >> canPropagate [
	^self containedBrowsers anySatisfy: [ :browser | browser canPropagate ]
]

{ #category : #testing }
MiAbstractWorkspace >> canReceiveEntity: anObject [
	^self containedBrowsers anySatisfy: [ :browser | browser canReceiveEntity: anObject ]
]

{ #category : #accessing }
MiAbstractWorkspace >> containedBrowsers [
	self subclassResponsibility 
]

{ #category : #'private - updating' }
MiAbstractWorkspace >> desiredWindowSize [
	self subclassResponsibility 
]

{ #category : #buses }
MiAbstractWorkspace >> followBus: aBus [

	(self buses includes: aBus) ifTrue: [ ^ self ].
	self buses add: aBus.
	aBus registerBrowser: self.
	self window ifNotNil: [ :window | window updateBusButton ].
	self selectEntity: aBus logger mostRecentEntity
]

{ #category : #actions }
MiAbstractWorkspace >> followEntity: anEntity [
	^self privateBus globallySelect: anEntity 
]

{ #category : #actions }
MiAbstractWorkspace >> freezeDuring: aBlock [

	| previousMode |
	previousMode := receivingMode.

	receivingMode := MiFreezeMode.

	aBlock ensure: [ receivingMode := previousMode ]
]

{ #category : #actions }
MiAbstractWorkspace >> highlightEntity: anEntity [
	"In HighlightMode, we propagate the entity to the containedBrowsers that are in the same mode and will act accrodingly"
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
MiAbstractWorkspace >> initializeLayout [

	self layout: self class defaultSpec
]

{ #category : #initialization }
MiAbstractWorkspace >> initializePrivateBus [
	privateBus := MiPrivateBus new
		name: 'workspace bus'.
	privateBus registerBrowser: self
]

{ #category : #initialization }
MiAbstractWorkspace >> initializeWindow: aMiWindowPresenter [

	super initializeWindow: aMiWindowPresenter.

	aMiWindowPresenter buildToolbar.

	aMiWindowPresenter whenClosedDo: [ 
		self buses do: [ :bus | bus unregisterBrowser: self ] ].

]

{ #category : #actions }
MiAbstractWorkspace >> install: aMiBrowser inContainer: aMiDropInContainer [
	"remove previous containedBrowser from privateBus
	 remove aMiBrowser from its former privateBus
	 puts aMiBrowser on receiver's privateBus (need to set receiving mode for this)
	 puts aMiBrowser in aMiDropInContainer and redisplay window"
	aMiDropInContainer installedPresenter
		ifNotNil: [ :previousBrowser | previousBrowser unfollowPrivateBus].

	aMiBrowser unfollowPrivateBus.
	aMiBrowser receivingMode: self receivingMode.
	aMiBrowser followPrivateBus: self privateBus.

	aMiDropInContainer install: aMiBrowser.
	
	self updateWindow
]

{ #category : #testing }
MiAbstractWorkspace >> isMiBrowser [
	^ true
]

{ #category : #accessing }
MiAbstractWorkspace >> miSelectedItem [
	^privateBus mostRecentEntity
		ifNil: [ (MiNoSelectedElementToPropagateException browser: self) signal ]
]

{ #category : #testing }
MiAbstractWorkspace >> needUpdate: anEntity [
	^self containedBrowsers anySatisfy: [ :browser | browser needUpdate: anEntity ]
]

{ #category : #'instance creation' }
MiAbstractWorkspace >> newContainer [
	^self instantiate: MiSingleDropInContainer
]

{ #category : #'private - updating' }
MiAbstractWorkspace >> noteThatWidgetHasBeenClosed: aBrowser [
	self shouldBeImplemented
]

{ #category : #buses }
MiAbstractWorkspace >> privateBus [
	^privateBus
]

{ #category : #buses }
MiAbstractWorkspace >> receiveFromPrivateBus: anEntity [
	"propagating on privateBus as no effect on workspace,
	 the privateBus takes care of propagating to contained browser(s)"
	
]

{ #category : #accessing }
MiAbstractWorkspace >> receivingMode [

	^ receivingMode
]

{ #category : #accessing }
MiAbstractWorkspace >> receivingMode: aReceivingMode [
	"for Follow and Highlight, we need to update containedBrowsers,
	for Frozen, it is handled by the workspace, so it makes no difference"
	receivingMode := aReceivingMode.
	self containedBrowsers do: [ :containedBrowser | containedBrowser receivingMode: aReceivingMode ]

]

{ #category : #'private - updating' }
MiAbstractWorkspace >> resetLayout [

	^self initializeLayout 
]

{ #category : #accessing }
MiAbstractWorkspace >> selectEntity: anEntity [

	"I am used by the Mi Application. You should use #globallySelect: anEntity that will transmit the message to me and the other browsers"

	receivingMode browser: self actOnEntity: anEntity.
	self updateToolbar
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
	self window ifNotNil: [ :window | window updateBusButton ]
]

{ #category : #'private - updating' }
MiAbstractWorkspace >> updateTitle [
	self hasWindow
		ifTrue: [ self window title: self title]
	
]

{ #category : #'private - updating' }
MiAbstractWorkspace >> updateToolbar [

	self window ifNotNil: [ :window | window updateToolbar ]
]

{ #category : #'private - updating' }
MiAbstractWorkspace >> updateWindow [
	self updateTitle.
	self updateWindowSize.
	self updateToolbar.
	self resetLayout
]

{ #category : #'private - updating' }
MiAbstractWorkspace >> updateWindowSize [
		self hasWindow
		ifTrue: [ self window resize: self desiredWindowSize ]
]
