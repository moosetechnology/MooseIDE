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
MiUMLBrowserTest >> testActivateActionButtons [
	{ MiInspectCommand . MiPropagateCommand }
	do: [ :cmdClass | self deny: (self actionButton: cmdClass) isEnabled ].
	self assert: (self actionButton: MiDragWindowCommand) isEnabled.

	browser receiveEntity: (FamixStClass named: 'TestClass').

	{ MiInspectCommand . MiPropagateCommand . MiDragWindowCommand }
	do: [ :cmdClass | self assert: (self actionButton: cmdClass) isEnabled ].

]

{ #category : #tests }
MiUMLBrowserTest >> testMiSelectedItem [

	| entityToSelect |
	self should: [browser miSelectedItem] raise: MiNoSelectedElementToPropagateException.

	entityToSelect := FamixStClass named: 'TestClass'.
	browser receiveEntity: entityToSelect.

	self assert: browser miSelectedItem equals: entityToSelect
]
