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

	{ MiInspectCommand . MiPropagateCommand . MiDragWindowCommand }
	do: [ :cmdClass | self deny: (self actionButton: cmdClass) isEnabled ].

	browser selectEntity: (FamixStClass named: 'TestClass').

	{ MiInspectCommand . MiPropagateCommand }
	do: [ :cmdClass | self assert: (self actionButton: cmdClass) isEnabled ].
	self deny: (self actionButton: MiDragWindowCommand) isEnabled
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
