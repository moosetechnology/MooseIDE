Class {
	#name : #MiLogsBrowserTest,
	#superclass : #MiAbstractBrowserTest,
	#instVars : [
		'newBrowser'
	],
	#category : #'MooseIDE-Tests-Browsers'
}

{ #category : #running }
MiLogsBrowserTest >> browserClass [

	^ MiLogsBrowser
]

{ #category : #running }
MiLogsBrowserTest >> receiveEntityToSelect [

	self bus globallySelect: entityToSelect
]

{ #category : #running }
MiLogsBrowserTest >> tearDown [

	newBrowser ifNotNil: [ newBrowser window close ].
	super tearDown
]

{ #category : #tests }
MiLogsBrowserTest >> testCanTagEntities [
	self deny: browser canTagEntities 
]

{ #category : #tests }
MiLogsBrowserTest >> testMiSelectedItem [

	self assert: browser miSelectedItem isNil.

	self bus globallySelect: entityToSelect.

	self assert: browser miSelectedItem equals: entityToSelect
]
