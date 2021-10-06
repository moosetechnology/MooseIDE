Class {
	#name : #MiFameBrowserTest,
	#superclass : #MiAbstractBrowserTest,
	#category : #'MooseIDE-Tests-Browsers'
}

{ #category : #running }
MiFameBrowserTest >> browserClass [
	^ MiFameBrowser
]

{ #category : #tests }
MiFameBrowserTest >> testMiActivateActionButtons [

	| itemToSelect |
	browser actionButtons do: [ :button | self deny: button isEnabled ].

	itemToSelect := FamixStClass named: 'TestClass'.
	browser selectEntity: itemToSelect.
	browser actionButtons do: [ :button | self assert: button isEnabled ]
]

{ #category : #tests }
MiFameBrowserTest >> testMiSelectedItem [

	| itemToSelect |
	self assert: browser miSelectedItem isNil.

	itemToSelect := FamixStClass named: 'TestClass'.
	browser selectEntity: itemToSelect.
	self assert: browser miSelectedItem equals: itemToSelect
]
