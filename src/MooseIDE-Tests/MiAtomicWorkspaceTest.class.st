"
A test class for MiAtomicWorkspace

MiAtomicWorkspace does not inherit from MiAbstractBrowser, but it shares a lot of behaviour, so it make sense that this class inherits from MiAbstractBrowserTest
"
Class {
	#name : #MiAtomicWorkspaceTest,
	#superclass : #MiAbstractWorkspaceTest,
	#instVars : [
		'mockBrowser'
	],
	#category : #'MooseIDE-Tests-Browsers'
}

{ #category : #running }
MiAtomicWorkspaceTest >> browserClass [
	^MiAtomicWorkspace
]

{ #category : #running }
MiAtomicWorkspaceTest >> setUp [
	super setUp.

	mockBrowser := MiMockBrowserForTests new.
	browser containedBrowser: mockBrowser

]

{ #category : #tests }
MiAtomicWorkspaceTest >> testCanChangeContainedBrowser [
	| nullBrowser |
	
	nullBrowser := MiNullBrowser new.
	browser containedBrowser: nullBrowser.
	
		self assert: browser containedBrowser equals: nullBrowser

]

{ #category : #tests }
MiAtomicWorkspaceTest >> testChangingContainedBrowserUpdatesPrivateBus [
	| nullBrowser |

	self assert: browser privateBus browsers size equals: 2.
	self assert: (browser privateBus browsers includes: browser).
	self assert: (browser privateBus browsers includes: mockBrowser).
	
	nullBrowser := MiNullBrowser new.
	browser containedBrowser: nullBrowser.
	
	self assert: browser privateBus browsers size equals: 2.
	self assert: (browser privateBus browsers includes: browser).
	self assert: (browser privateBus browsers includes: nullBrowser).
]

{ #category : #tests }
MiAtomicWorkspaceTest >> testDelegatesCanFollow [

	self deny: browser canFollow.
	mockBrowser canFollow: true.
	self assert: browser canFollow.
]

{ #category : #tests }
MiAtomicWorkspaceTest >> testDelegatesCanHighlight [

	self deny: browser canHighlight.
	mockBrowser canHighlight: true.
	self assert: browser canHighlight.
]

{ #category : #tests }
MiAtomicWorkspaceTest >> testDelegatesCanPropagate [

	self deny: browser canPropagate.
	mockBrowser canPropagate: true.
	self assert: browser canPropagate.
]

{ #category : #tests }
MiAtomicWorkspaceTest >> testDelegatesCanReceiveEntity [

	self deny: (browser canFollowEntity: nil).
	mockBrowser canReceive: true.
	self assert: (browser canFollowEntity: nil).
]

{ #category : #tests }
MiAtomicWorkspaceTest >> testDelegatesNeedUpdate [

	self deny: (browser needUpdate: nil).
	mockBrowser toUpdate: true.
	self assert: (browser needUpdate: nil).
]

{ #category : #tests }
MiAtomicWorkspaceTest >> testPrivateBusPropagatesToContainedBrowser [
	
	browser containedBrowser canReceive: true. 
	browser privateBus globallySelect: #aMockEntity.
	
	self assert: browser miSelectedItem equals: #aMockEntity
]

{ #category : #tests }
MiAtomicWorkspaceTest >> testPropagatesReceivingMode [
	{ MiHighlightCommand . MiFreezeCommand  . MiFollowCommand }
	do: [ :mode |
		browser receivingMode: mode.
		self assert: mockBrowser receivingMode equals: mode
	]
]

{ #category : #tests }
MiAtomicWorkspaceTest >> testWindowSizeChangesWithContainedBrowser [
	"Workspace first created with a MiNullBrowser and changing the containedBrowser does not changes the windowSize"
	self assert: browser window initialExtent equals: MiNullBrowser windowSize
]

{ #category : #tests }
MiAtomicWorkspaceTest >> testWindowTitleChangesWithContainedBrowser [

	self assert: browser window title equals: MiMockBrowserForTests title
]
