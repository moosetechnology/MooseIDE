Class {
	#name : #MiFullWorkspaceTest,
	#superclass : #MiAbstractWorkspaceTest,
	#instVars : [
		'mockBrowser1',
		'mockBrowser2'
	],
	#category : #'MooseIDE-Tests-Browsers'
}

{ #category : #running }
MiFullWorkspaceTest >> browserClass [
	^MiFullWorkspace
]

{ #category : #initialization }
MiFullWorkspaceTest >> setUp [
	super setUp.

	mockBrowser1 := MiMockBrowserForTests new.
	mockBrowser2 := MiMockBrowserForTests new.
]

{ #category : #tests }
MiFullWorkspaceTest >> testCanChangeContainedBrowsers [
	
	self assert: browser containedBrowsers size equals: 0.

	browser at: 1 putBrowser: mockBrowser1.
	self assert: browser containedBrowsers size equals: 1.

	browser at: 1 putBrowser: mockBrowser2.
	self assert: browser containedBrowsers size equals: 1.

	browser at: 2 putBrowser: mockBrowser1.
	self assert: browser containedBrowsers size equals: 2.

]

{ #category : #tests }
MiFullWorkspaceTest >> testCanReceiveEntity [
	self assert: (browser canReceiveEntity: nil).

]

{ #category : #tests }
MiFullWorkspaceTest >> testContainedBrowsersDefaultReceivingMode [

	self assert: mockBrowser1 receivingMode isNil.
	
	browser at: 1 putBrowser: mockBrowser1.
	self assert: mockBrowser1 receivingMode equals: MiFollowMode.

]

{ #category : #tests }
MiFullWorkspaceTest >> testDelegatesCanFollow [
	self deny: browser canFollow.

	browser at: 1 putBrowser: mockBrowser1.
	browser at: 2 putBrowser: mockBrowser2.
	
	mockBrowser1 canFollow: false.
	mockBrowser2 canFollow: false.
	self deny: browser canFollow.

	mockBrowser2 canFollow: true.
	self assert: browser canFollow.
]

{ #category : #tests }
MiFullWorkspaceTest >> testDelegatesCanHighlight [
	self deny: browser canHighlight.

	browser at: 1 putBrowser: mockBrowser1.
	browser at: 2 putBrowser: mockBrowser2.
	
	mockBrowser1 canHighlight: false.
	mockBrowser2 canHighlight: false.
	self deny: browser canHighlight.

	mockBrowser2 canHighlight: true.
	self assert: browser canHighlight.
]

{ #category : #tests }
MiFullWorkspaceTest >> testDelegatesCanPropagate [
	self deny: browser canPropagate.

	browser at: 1 putBrowser: mockBrowser1.
	browser at: 2 putBrowser: mockBrowser2.
	
	mockBrowser1 canPropagate: false.
	mockBrowser2 canPropagate: false.
	self deny: browser canPropagate.

	mockBrowser2 canPropagate: true.
	self assert: browser canPropagate.
]

{ #category : #tests }
MiFullWorkspaceTest >> testDelegatesNeedUpdate [
	self deny: (browser needUpdate: nil).
	
	browser at: 1 putBrowser: mockBrowser1.
	browser at: 2 putBrowser: mockBrowser2.
	
	mockBrowser1 toUpdate: false.
	mockBrowser2 toUpdate: false.
	self deny: (browser needUpdate: nil).

	mockBrowser2 toUpdate: true.
	self assert: (browser needUpdate: nil).
]

{ #category : #tests }
MiFullWorkspaceTest >> testPrivateBusPropagatesToContainedBrowsers [
	
	browser at: 1 putBrowser: mockBrowser1.
	browser at: 2 putBrowser: mockBrowser2.

	mockBrowser1 receivingMode: MiFreezeMode.
	mockBrowser2 receivingMode: MiFollowMode.
	mockBrowser2 canReceive: true.
	
	browser privateBus globallySelect: #aMockEntity.
	
	self assert: mockBrowser1 miSelectedItem isNil.
	self assert: mockBrowser2 miSelectedItem equals: #aMockEntity
]

{ #category : #tests }
MiFullWorkspaceTest >> testPropagatesReceivingMode [

	browser at: 1 putBrowser: mockBrowser1.
	browser at: 2 putBrowser: mockBrowser2.
	
	{ MiHighlightCommand . MiFreezeCommand  . MiFollowCommand }
	do: [ :mode |
		browser receivingMode: mode.
		self assert: mockBrowser1 receivingMode equals: mode.
		self assert: mockBrowser2 receivingMode equals: mode
	]
]
