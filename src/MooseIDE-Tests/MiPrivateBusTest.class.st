Class {
	#name : #MiPrivateBusTest,
	#superclass : #TestCase,
	#instVars : [
		'bus',
		'privateBus',
		'browser',
		'workspace'
	],
	#category : #'MooseIDE-Tests-Application'
}

{ #category : #running }
MiPrivateBusTest >> setUp [

	super setUp.
	workspace := MiAtomicWorkspace new containedBrowser:
		             MiMockBrowserForTests new
]

{ #category : #tests }
MiPrivateBusTest >> testInitializeWithHollowLogger [

	self assert: workspace privateBus logger class equals: MiHollowLogger
]

{ #category : #tests }
MiPrivateBusTest >> testNormalLoggerAfterFirstLog [

	workspace followEntity: FamixStClass new.

	self
		assert: workspace privateBus logger class
		equals: MiPrivateLogger
]
