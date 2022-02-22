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
	{ MiInspectCommand . MiPropagateCommand . MiDragWindowCommand }
	do: [ :cmdClass | self deny: (self actionButton: cmdClass) isEnabled ].

	browser receiveEntity: (FamixStClass named: 'TestClass').

	{ MiInspectCommand . MiPropagateCommand }
	do: [ :cmdClass | self assert: (self actionButton: cmdClass) isEnabled ].
	self deny: (self actionButton: MiDragWindowCommand) isEnabled.

]

{ #category : #tests }
MiTreeBrowserTest >> testMiSelectedItem [

	| entityToSelect |
	self assert: browser miSelectedItem isNil.

	entityToSelect := FamixStClass named: 'TestClass'.
	browser followEntity: entityToSelect.

	self assert: browser miSelectedItem equals: entityToSelect
]
