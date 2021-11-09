"
A test class for MiAtomicWorkspace

MiAtomicWorkspace does not inherit from MiAbstractBrowser, but it shares a lot of behaviour, so it make sense that this class inherits from MiAbstractBrowserTest
"
Class {
	#name : #MiWorkspaceAtomicTest,
	#superclass : #MiAbstractBrowserTest,
	#instVars : [
		'mockBrowser'
	],
	#category : #'MooseIDE-Tests-Browsers'
}

{ #category : #running }
MiWorkspaceAtomicTest >> browserClass [
	^MiAtomicWorkspace
]

{ #category : #running }
MiWorkspaceAtomicTest >> setUp [
	super setUp.

	mockBrowser := MiMockBrowserForTests new.
	browser containedBrowser: mockBrowser

]

{ #category : #tests }
MiWorkspaceAtomicTest >> testCanChangeContainedBrowser [
	| nullBrowser |

	self assert: browser privateBus browsers size equals: 2.
	self assert: (browser privateBus browsers includes: browser).
	self assert: (browser privateBus browsers includes: mockBrowser).
	
	nullBrowser := MiNullBrowser new.
	browser containedBrowser: nullBrowser.
	
	self assert: browser containedBrowser equals: nullBrowser.
	self assert: browser privateBus browsers size equals: 2.
	self assert: (browser privateBus browsers includes: browser).
	self assert: (browser privateBus browsers includes: nullBrowser).
]

{ #category : #tests }
MiWorkspaceAtomicTest >> testDelegatesCanFollow [

	self deny: browser canFollow.
	mockBrowser canFollow: true.
	self assert: browser canFollow.
]

{ #category : #tests }
MiWorkspaceAtomicTest >> testDelegatesCanHighlight [

	self deny: browser canHighlight.
	mockBrowser canHighlight: true.
	self assert: browser canHighlight.
]

{ #category : #tests }
MiWorkspaceAtomicTest >> testDelegatesCanPropagate [

	self deny: browser canPropagate.
	mockBrowser canPropagate: true.
	self assert: browser canPropagate.
]

{ #category : #tests }
MiWorkspaceAtomicTest >> testDelegatesCanReceiveEntity [

	self deny: (browser canReceiveEntity: nil).
	mockBrowser canReceive: true.
	self assert: (browser canReceiveEntity: nil).
]

{ #category : #tests }
MiWorkspaceAtomicTest >> testDelegatesNeedUpdate [

	self deny: (browser needUpdate: nil).
	mockBrowser toUpdate: true.
	self assert: (browser needUpdate: nil).
]

{ #category : #tests }
MiWorkspaceAtomicTest >> testPrivateBusPropagatesToContainedBrowser [
	
	browser containedBrowser canReceive: true. 
	browser privateBus globallySelect: #aMockEntity.
	
	self assert: browser miSelectedItem equals: #aMockEntity
]

{ #category : #tests }
MiWorkspaceAtomicTest >> testWindowSizeChangesWithContainedBrowser [
	"Workspace first created with a MiNullBrowser and changing the containedBrowser does not changes the windowSize"
	self assert: browser window initialExtent equals: MiNullBrowser windowSize
]

{ #category : #tests }
MiWorkspaceAtomicTest >> testWindowTitleChangesWithContainedBrowser [

	self assert: browser window title equals: MiMockBrowserForTests title
]
