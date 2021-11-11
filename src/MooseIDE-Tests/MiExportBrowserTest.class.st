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

	{ MiInspectCommand . MiPropagateCommand }
	do: [ :cmdClass | self deny: (self actionButton: cmdClass) isEnabled ].
	self assert: (self actionButton: MiDragWindowCommand) isEnabled.

	browser selectEntity: (FamixStClass named: 'TestClass').

	{ MiInspectCommand . MiPropagateCommand . MiDragWindowCommand }
	do: [ :cmdClass | self assert: (self actionButton: cmdClass) isEnabled ].
]

{ #category : #tests }
MiExportBrowserTest >> testMiSelectedItem [

	| entityToSelect |
	self should: [browser miSelectedItem] raise: MiNoSelectedElementToPropagateException.

	entityToSelect := FamixStClass named: 'TestClass'.
	browser followEntity: entityToSelect.

	self assert: browser miSelectedItem equals: entityToSelect
]
