Class {
	#name : #MiLogBrowserTest,
	#superclass : #MiAbstractBrowserTest,
	#category : #'Midas-Tests-Browsers'
}

{ #category : #asserting }
MiLogBrowserTest >> assertFollowActionFor: aMooseObject [
	self
		assert:
			(browser entryList items
				anySatisfy: [ :log | log entity == aMooseObject ])
]

{ #category : #running }
MiLogBrowserTest >> browserClass [
	^ MiLogBrowser
]

{ #category : #running }
MiLogBrowserTest >> testLogger [
	self assert: browser logger identicalTo: browser bus logger.
	self assert: browser logger identicalTo: self bus logger
]
