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

]

{ #category : #tests }
MiWorkspaceAtomicTest >> testCanSetContainedBrowser [

	browser containedBrowser: mockBrowser.
	
	self assert: browser containedBrowser equals: mockBrowser
]

{ #category : #tests }
MiWorkspaceAtomicTest >> testDelegatesCanFollow [

	browser containedBrowser: mockBrowser.
	
	self deny: browser canFollow.
	mockBrowser canFollow: true.
	self assert: browser canFollow.
]

{ #category : #tests }
MiWorkspaceAtomicTest >> testDelegatesCanHighlight [

	browser containedBrowser: mockBrowser.
	
	self deny: browser canHighlight.
	mockBrowser canHighlight: true.
	self assert: browser canHighlight.
]

{ #category : #tests }
MiWorkspaceAtomicTest >> testDelegatesCanPropagate [

	browser containedBrowser: mockBrowser.
	
	self deny: browser canPropagate.
	mockBrowser canPropagate: true.
	self assert: browser canPropagate.
]

{ #category : #tests }
MiWorkspaceAtomicTest >> testDelegatesCanReceiveEntity [

	browser containedBrowser: mockBrowser.
	
	self deny: (browser canReceiveEntity: nil).
	mockBrowser canReceive: true.
	self assert: (browser canReceiveEntity: nil).
]

{ #category : #tests }
MiWorkspaceAtomicTest >> testDelegatesNeedUpdate [

	browser containedBrowser: mockBrowser.
	
	self deny: (browser needUpdate: nil).
	mockBrowser toUpdate: true.
	self assert: (browser needUpdate: nil).
]

{ #category : #tests }
MiWorkspaceAtomicTest >> testDelegatesSelectedItem [

	browser containedBrowser: mockBrowser.
	
	mockBrowser selectedItem: #aSelectedItem.
	self assert: browser miSelectedItem equals: #aSelectedItem.
]

{ #category : #tests }
MiWorkspaceAtomicTest >> testWindowSizeChangesWithContainedBrowser [

	browser containedBrowser: mockBrowser.
	
	self assert: browser window title equals: MiMockBrowserForTests title
]

{ #category : #tests }
MiWorkspaceAtomicTest >> testWindowTitleChangesWithContainedBrowser [

	browser containedBrowser: mockBrowser.
	
	self assert: browser window title equals: MiMockBrowserForTests title
]
