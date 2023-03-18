Class {
	#name : #MiBusLogBrowserTest,
	#superclass : #MiAbstractBrowserTest,
	#instVars : [
		'newBrowser',
		'entityToSelect'
	],
	#category : #'MooseIDE-Tests-Browsers'
}

{ #category : #running }
MiBusLogBrowserTest >> browserClass [

	^ MiBusLogBrowser
]

{ #category : #initialization }
MiBusLogBrowserTest >> setUp [

	super setUp.
	entityToSelect := FamixStClass named: 'TestClass'
]

{ #category : #running }
MiBusLogBrowserTest >> tearDown [

	newBrowser ifNotNil: [ newBrowser window close ].
	super tearDown
]

{ #category : #tests }
MiBusLogBrowserTest >> testActivateActionButtons [

	browser actionButtons do: [ :button | self deny: button isEnabled ].

	self bus globallySelect: entityToSelect.
	browser actionButtons do: [ :button | self assert: button isEnabled ]
]

{ #category : #tests }
MiBusLogBrowserTest >> testActivateLocalActionButtons [

	browser localActionButtons do: [ :button | self deny: button isEnabled ].
	
	self bus globallySelect: entityToSelect.
	browser localActionButtons do: [ :button | self assert: button isEnabled ]
]

{ #category : #tests }
MiBusLogBrowserTest >> testCanTagEntities [
	self deny: browser canTagEntities 
]

{ #category : #tests }
MiBusLogBrowserTest >> testMiSelectedItem [

	self assert: browser miSelectedItem isNil.

	self bus globallySelect: entityToSelect.

	self assert: browser miSelectedItem equals: entityToSelect
]

{ #category : #running }
MiBusLogBrowserTest >> testOpenOnLatestEntity [

	self assert: browser miSelectedItem isNil.

	self bus globallySelect: entityToSelect.

	newBrowser := self browserClass openForTests: self application.
	self assert: newBrowser miSelectedItem equals: entityToSelect
]
