Class {
	#name : #MiFameBrowserTest,
	#superclass : #MiAbstractBrowserTest,
	#instVars : [
		'entityToSelect'
	],
	#category : #'MooseIDE-Tests-Browsers'
}

{ #category : #running }
MiFameBrowserTest >> browserClass [
	^ MiFameBrowser
]

{ #category : #initialization }
MiFameBrowserTest >> setUp [

	super setUp.
	entityToSelect := FamixStClass named: 'TestClass'
]

{ #category : #tests }
MiFameBrowserTest >> testActivateActionButtons [

	browser actionButtons do: [ :button | self deny: button isEnabled ].

	browser receiveEntity: entityToSelect.
	browser actionButtons do: [ :button | self assert: button isEnabled ]
]

{ #category : #tests }
MiFameBrowserTest >> testCanTagEntities [
	self deny: browser canTagEntities 
]

{ #category : #tests }
MiFameBrowserTest >> testMiSelectedItem [

	self assert: browser miSelectedItem isNil.

	browser receiveEntity: entityToSelect.
	self assert: browser miSelectedItem equals: entityToSelect
]
