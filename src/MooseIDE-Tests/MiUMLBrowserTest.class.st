Class {
	#name : #MiUMLBrowserTest,
	#superclass : #MiAbstractBrowserTest,
	#category : #'MooseIDE-Tests-Browsers'
}

{ #category : #running }
MiUMLBrowserTest >> browserClass [
	^ MiUMLBrowser
]

{ #category : #tests }
MiUMLBrowserTest >> testMiActivateActionButtons [

	browser actionButtons do: [ :button | self deny: button isEnabled ].

	browser followEntity: (FamixStClass named: 'TestClass').

	browser actionButtons do: [ :button | self assert: button isEnabled ]
]

{ #category : #tests }
MiUMLBrowserTest >> testMiSelectedItem [

	| entityToSelect |
	self assert: browser miSelectedItem isNil.

	entityToSelect := FamixStClass named: 'TestClass'.
	browser followEntity: entityToSelect.

	self assert: browser miSelectedItem equals: entityToSelect
]
