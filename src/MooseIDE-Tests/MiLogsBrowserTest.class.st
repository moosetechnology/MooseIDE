Class {
	#name : #MiLogsBrowserTest,
	#superclass : #MiAbstractBrowserTest,
	#instVars : [
		'entityToSelect',
		'newBrowser'
	],
	#category : #'MooseIDE-Tests-Browsers'
}

{ #category : #running }
MiLogsBrowserTest >> browserClass [

	^ MiLogsBrowser
]

{ #category : #tests }
MiLogsBrowserTest >> setEntityToSelect [ 

	self bus globallySelect: entityToSelect.
]

{ #category : #running }
MiLogsBrowserTest >> setUp [

	super setUp.
	entityToSelect := FamixStClass named: 'TestClass'
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
