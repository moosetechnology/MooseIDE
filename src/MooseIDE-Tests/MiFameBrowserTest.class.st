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

	browser selectEntity: entityToSelect.
	browser actionButtons do: [ :button | self assert: button isEnabled ]
]

{ #category : #tests }
MiFameBrowserTest >> testMiSelectedItem [

	self assert: browser miSelectedItem isNil.

	browser selectEntity: entityToSelect.
	self assert: browser miSelectedItem equals: entityToSelect
]
