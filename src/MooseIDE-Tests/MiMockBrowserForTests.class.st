"
I am a mock browser for the tests of MiWorkspaces

Could have done it Mocketry, but it was not working :-(
"
Class {
	#name : #MiMockBrowserForTests,
	#superclass : #MiNullBrowser,
	#instVars : [
		'canFollow',
		'canHighlight',
		'canPropagate',
		'canReceive',
		'selected',
		'toUpdate'
	],
	#category : #'MooseIDE-Tests-Browsers'
}

{ #category : #accessing }
MiMockBrowserForTests class >> title [
	^'Mock-browser'
]

{ #category : #accessing }
MiMockBrowserForTests class >> windowSize [
	^100@100
]

{ #category : #accessing }
MiMockBrowserForTests >> canFollow [

	^ canFollow
]

{ #category : #accessing }
MiMockBrowserForTests >> canFollow: anObject [

	canFollow := anObject
]

{ #category : #accessing }
MiMockBrowserForTests >> canHighlight [

	^canHighlight
]

{ #category : #accessing }
MiMockBrowserForTests >> canHighlight: anObject [

	canHighlight := anObject
]

{ #category : #accessing }
MiMockBrowserForTests >> canPropagate [

	^canPropagate
]

{ #category : #accessing }
MiMockBrowserForTests >> canPropagate: anObject [

	canPropagate := anObject
]

{ #category : #accessing }
MiMockBrowserForTests >> canReceive [

	^ canReceive
]

{ #category : #accessing }
MiMockBrowserForTests >> canReceive: anObject [

	canReceive := anObject
]

{ #category : #accessing }
MiMockBrowserForTests >> canReceiveEntity: whatever [

	^canReceive
]

{ #category : #initialization }
MiMockBrowserForTests >> initialize [
	super initialize.
	canFollow := false.
	canHighlight := false.
	canPropagate := false.
	canReceive := false.
	toUpdate := false.
]

{ #category : #accessing }
MiMockBrowserForTests >> miSelectedItem [

	^ selected
]

{ #category : #accessing }
MiMockBrowserForTests >> needUpdate: whatever [

	^toUpdate
]

{ #category : #accessing }
MiMockBrowserForTests >> selectedItem: anObject [

	selected := anObject
]

{ #category : #accessing }
MiMockBrowserForTests >> toUpdate [

	^ toUpdate
]

{ #category : #accessing }
MiMockBrowserForTests >> toUpdate: anObject [

	toUpdate := anObject
]
