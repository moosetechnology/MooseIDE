"
I represent a ""Workspace"" where several Mi Browsers can be inserted to all work within a single window

The workspace has a private bus that all internal tools will be attached to.
The workspace will make a bridge between this private bus and any external bus it is attached too
"
Class {
	#name : #MiPanedWorkspace,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'workspace',
		'privateBus'
	],
	#category : #'MooseIDE-NewTools-PanedWorkspace'
}

{ #category : #'instance creation' }
MiPanedWorkspace class >> open [

	"This method implementation is the same as their parent. But it is here for opening this browser more confortably from the system's browser."

	<script>
	^ super open
]

{ #category : #'instance creation' }
MiPanedWorkspace class >> title [

	^ 'Moose IDE Workspace'
]

{ #category : #'instance creation' }
MiPanedWorkspace class >> windowSize [

	^ 1350 @ 600
]

{ #category : #actions }
MiPanedWorkspace >> accept: anEntity [

    ^ true

]

{ #category : #actions }
MiPanedWorkspace >> followAction [

    (self accept: toSelect) ifFalse: [ ^ self ].
    self freezeDuring: [privateBus globallySelect: toSelect]
]

{ #category : #initialization }
MiPanedWorkspace >> initialize [
	super initialize.
	privateBus := MiBus new
		name: 'workspace bus'.
	self followBus: privateBus 
]

{ #category : #initialization }
MiPanedWorkspace >> initializeDragButton [
	"For now we don't allow a MiWorkspace to be included in another MiWorkspace"
	btnDrag := self newNullPresenter 
]

{ #category : #initialization }
MiPanedWorkspace >> initializeLayout [
	self layout: (self class defaultSpec
		add: #workspace ;
		yourself)
]

{ #category : #initialization }
MiPanedWorkspace >> initializePresenters [
	super initializePresenters.

	workspace := self instantiate: SpDropInContainer.
	workspace beLeftToRight.
	
	self initializeLayout.
]

{ #category : #accessing }
MiPanedWorkspace >> privateBus [
	^privateBus
]
