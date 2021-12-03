Class {
	#name : #MiExportBrowserTest,
	#superclass : #MiAbstractBrowserTest,
	#category : #'MooseIDE-Tests-Browsers'
}

{ #category : #running }
MiExportBrowserTest >> browserClass [

	^ MiExportBrowser
]

{ #category : #tests }
MiExportBrowserTest >> testActivateActionButtons [

	browser actionButtons do: [ :button | self deny: button isEnabled ].

	browser selectEntity: (FamixStClass named: 'TestClass').

	browser actionButtons do: [ :button | self assert: button isEnabled ]
]

{ #category : #tests }
MiExportBrowserTest >> testMiSelectedItem [

	| entityToSelect |
	self assert: browser miSelectedItem isEmpty.

	entityToSelect := FamixStClass named: 'TestClass'.
	browser followEntity: entityToSelect.

	self assert: browser miSelectedItem size equals: 1.
	self assert: browser miSelectedItem anyOne equals: entityToSelect
]
