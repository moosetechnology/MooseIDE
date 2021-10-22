Class {
	#name : #MiLogBrowserTest,
	#superclass : #MiAbstractBrowserTest,
	#category : #'MooseIDE-Tests-Browsers'
}

{ #category : #running }
MiLogBrowserTest >> browserClass [
	^ MiLogBrowser
]

{ #category : #'tests - buses' }
MiLogBrowserTest >> testBusList [

	self assert: browser logsList presenters size equals: 1.
	self assert: browser logsList presenters first bus equals: self bus
]

{ #category : #'tests - buses' }
MiLogBrowserTest >> testBusListWhenFollowingTwoBuses [

	| otherBus |
	otherBus := self application busNamed: 'Other bus'.
	browser followBus: otherBus.

	self assert: browser logsList presenters size equals: 2.
	self assert:
		((browser logsList presenters collect: #bus) includes: otherBus)
]
