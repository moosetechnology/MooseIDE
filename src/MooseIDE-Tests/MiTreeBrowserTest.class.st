Class {
	#name : #MiTreeBrowserTest,
	#superclass : #MiAbstractBrowserTest,
	#category : #'MooseIDE-Tests-Browsers'
}

{ #category : #running }
MiTreeBrowserTest >> browserClass [
	^ MiTreeBrowser
]

{ #category : #tests }
MiTreeBrowserTest >> testActivateActionButtons [

	browser actionButtons do: [ :button | self deny: button isEnabled ].

	browser receiveEntity: (FamixStClass named: 'TestClass').

	browser actionButtons do: [ :button | self assert: button isEnabled ]
]

{ #category : #tests }
MiTreeBrowserTest >> testCanTagEntities [
	self deny: browser canTagEntities 
]

{ #category : #tests }
MiTreeBrowserTest >> testMiSelectedItem [

	| entityToSelect |
	self assert: browser miSelectedItem isNil.

	entityToSelect := FamixStClass named: 'TestClass'.
	browser followEntity: entityToSelect.

	self assert: browser miSelectedItem equals: entityToSelect
]
