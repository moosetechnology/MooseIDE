Class {
	#name : #MiLogBrowserTest,
	#superclass : #MiAbstractBrowserTest,
	#category : #'Midas-Tests-Browsers'
}

{ #category : #'tests - buses' }
MiLogBrowserTest >> assertFollowBuses: someBuses [
	super assertFollowBuses: someBuses.
	self
		assertCollection: (browser logsList presenters collect: #bus)
		hasSameElements: someBuses
]

{ #category : #running }
MiLogBrowserTest >> browserClass [
	^ MiLogBrowser
]
