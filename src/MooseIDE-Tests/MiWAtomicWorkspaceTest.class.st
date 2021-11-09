"
A test class for MiAtomicWorkspace

MiAtomicWorkspace does not inherit from MiAbstractBrowser, but it shares a lot of behaviour, so it make sense that this class inherits from MiAbstractBrowserTest
"
Class {
	#name : #MiWAtomicWorkspaceTest,
	#superclass : #MiAbstractBrowserTest,
	#instVars : [
		'mockBrowser'
	],
	#category : #'MooseIDE-Tests-Browsers'
}

{ #category : #running }
MiWAtomicWorkspaceTest >> browserClass [
	^MiAtomicWorkspace
]

{ #category : #running }
MiWAtomicWorkspaceTest >> setUp [
	super setUp.

	mockBrowser := MiMockBrowserForTests new.
	browser containedBrowser: mockBrowser

]

{ #category : #tests }
MiWAtomicWorkspaceTest >> testCanChangeContainedBrowser [
	| nullBrowser |
	
	nullBrowser := MiNullBrowser new.
	browser containedBrowser: nullBrowser.

]

{ #category : #tests }
MiWAtomicWorkspaceTest >> testChangingContainedBrowserUpdatesPrivateBus [
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
MiWAtomicWorkspaceTest >> testDelegatesCanFollow [

	self deny: browser canFollow.
	mockBrowser canFollow: true.
	self assert: browser canFollow.
]

{ #category : #tests }
MiWAtomicWorkspaceTest >> testDelegatesCanHighlight [

	self deny: browser canHighlight.
	mockBrowser canHighlight: true.
	self assert: browser canHighlight.
]

{ #category : #tests }
MiWAtomicWorkspaceTest >> testDelegatesCanPropagate [

	self deny: browser canPropagate.
	mockBrowser canPropagate: true.
	self assert: browser canPropagate.
]

{ #category : #tests }
MiWAtomicWorkspaceTest >> testDelegatesCanReceiveEntity [

	self deny: (browser canReceiveEntity: nil).
	mockBrowser canReceive: true.
	self assert: (browser canReceiveEntity: nil).
]

{ #category : #tests }
MiWAtomicWorkspaceTest >> testDelegatesNeedUpdate [

	self deny: (browser needUpdate: nil).
	mockBrowser toUpdate: true.
	self assert: (browser needUpdate: nil).
]

{ #category : #tests }
MiWAtomicWorkspaceTest >> testPrivateBusPropagatesToContainedBrowser [
	
	browser containedBrowser canReceive: true. 
	browser privateBus globallySelect: #aMockEntity.
	
	self assert: browser miSelectedItem equals: #aMockEntity
]

{ #category : #tests }
MiWAtomicWorkspaceTest >> testWindowSizeChangesWithContainedBrowser [
	"Workspace first created with a MiNullBrowser and changing the containedBrowser does not changes the windowSize"
	self assert: browser window initialExtent equals: MiNullBrowser windowSize
]

{ #category : #tests }
MiWAtomicWorkspaceTest >> testWindowTitleChangesWithContainedBrowser [

	self assert: browser window title equals: MiMockBrowserForTests title
]
