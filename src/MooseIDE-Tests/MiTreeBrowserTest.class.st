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
MiTreeBrowserTest >> testMiActivateActionButtons [

	browser actionButtons do: [ :button | self deny: button isEnabled ].

	browser followEntity: (FamixStClass named: 'TestClass').

	browser actionButtons do: [ :button | self assert: button isEnabled ]
]

{ #category : #tests }
MiTreeBrowserTest >> testMiSelectedItem [

	| entityToSelect |
	self assert: browser miSelectedItem isNil.

	entityToSelect := FamixStClass named: 'TestClass'.
	browser followEntity: entityToSelect.

	self assert: browser miSelectedItem equals: entityToSelect
]
