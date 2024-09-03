Class {
	#name : #MiBusLogBrowserTest,
	#superclass : #MiAbstractBrowserTest,
	#instVars : [
		'newBrowser'
	],
	#category : #'MooseIDE-Tests-Browsers'
}

{ #category : #running }
MiBusLogBrowserTest >> browserClass [

	^ MiBusLogBrowser
]

{ #category : #running }
MiBusLogBrowserTest >> receiveEntityToSelect [

	self bus globallySelect: entityToSelect
]

{ #category : #running }
MiBusLogBrowserTest >> tearDown [

	newBrowser ifNotNil: [ newBrowser window close ].
	super tearDown
]

{ #category : #tests }
MiBusLogBrowserTest >> testCanTagEntities [
	self deny: browser canTagEntities 
]

{ #category : #tests }
MiBusLogBrowserTest >> testMiSelectedItem [

	self assert: browser miSelectedItem isNil.

	self receiveEntityToSelect.

	self assert: browser miSelectedItem equals: entityToSelect
]

{ #category : #running }
MiBusLogBrowserTest >> testOpenOnLatestEntity [

	self assert: browser miSelectedItem isNil.

	self receiveEntityToSelect.

	newBrowser := self browserClass openForTests: self application.
	self assert: newBrowser miSelectedItem equals: entityToSelect
]
