Class {
	#name : #MiWFullWorkspaceTest,
	#superclass : #MiAbstractBrowserTest,
	#instVars : [
		'mockBrowser1',
		'mockBrowser2'
	],
	#category : #'MooseIDE-Tests-Browsers'
}

{ #category : #running }
MiWFullWorkspaceTest >> browserClass [
	^MiFullWorkspace
]

{ #category : #initialization }
MiWFullWorkspaceTest >> setUp [
	super setUp.

	mockBrowser1 := MiMockBrowserForTests new.
	mockBrowser2 := MiMockBrowserForTests new.
]

{ #category : #tests }
MiWFullWorkspaceTest >> testCanChangeContainedBrowsers [
	
	self assert: browser containedBrowsers size equals: 0.

	browser at: 1 putBrowser: mockBrowser1.
	self assert: browser containedBrowsers size equals: 1.

	browser at: 1 putBrowser: mockBrowser2.
	self assert: browser containedBrowsers size equals: 1.

	browser at: 2 putBrowser: mockBrowser1.
	self assert: browser containedBrowsers size equals: 2.

]

{ #category : #tests }
MiWFullWorkspaceTest >> testCanReceiveEntity [
	self assert: (browser canReceiveEntity: nil).

]

{ #category : #tests }
MiWFullWorkspaceTest >> testDelegatesCanFollow [
	self deny: browser canFollow.
	
	browser at: 1 putBrowser: mockBrowser1.
	
	mockBrowser1 canFollow: false.
	self deny: browser canFollow.

	mockBrowser1 canFollow: true.
	self assert: browser canFollow.
]

{ #category : #tests }
MiWFullWorkspaceTest >> testDelegatesCanHighlight [
	self deny: browser canHighlight.
	
	browser at: 1 putBrowser: mockBrowser1.
	
	mockBrowser1 canHighlight: false.
	self deny: browser canHighlight.

	mockBrowser1 canHighlight: true.
	self assert: browser canHighlight.
]

{ #category : #tests }
MiWFullWorkspaceTest >> testDelegatesCanPropagate [
	self deny: browser canPropagate.
	
	browser at: 1 putBrowser: mockBrowser1.
	
	mockBrowser1 canPropagate: false.
	self deny: browser canPropagate.

	mockBrowser1 canPropagate: true.
	self assert: browser canPropagate.
]

{ #category : #tests }
MiWFullWorkspaceTest >> testDelegatesNeedUpdate [
	self deny: (browser needUpdate: nil).
	
	browser at: 1 putBrowser: mockBrowser1.
	
	mockBrowser1 toUpdate: false.
	self deny: (browser needUpdate: nil).

	mockBrowser1 toUpdate: true.
	self assert: (browser needUpdate: nil).
]
