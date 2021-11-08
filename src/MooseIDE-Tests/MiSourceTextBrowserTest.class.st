Class {
	#name : #MiSourceTextBrowserTest,
	#superclass : #MiAbstractBrowserTest,
	#category : #'MooseIDE-Tests-Browsers'
}

{ #category : #running }
MiSourceTextBrowserTest >> browserClass [
	^ MiSourceTextBrowser
]

{ #category : #tests }
MiSourceTextBrowserTest >> testActivateActionButtons [
	{ MiInspectCommand . MiPropagateCommand }
	do: [ :cmdClass | self deny: (self actionButton: cmdClass) isEnabled ].
	self assert: (self actionButton: MiDragWindowCommand) isEnabled.

	browser selectEntity: (FamixStClass named: 'TestClass').

	{ MiInspectCommand . MiPropagateCommand . MiDragWindowCommand }
	do: [ :cmdClass | self assert: (self actionButton: cmdClass) isEnabled ].

]

{ #category : #tests }
MiSourceTextBrowserTest >> testMiSelectedItem [

	| entityToSelect |
	self assert: browser miSelectedItem isNil.

	entityToSelect := FamixStClass named: 'TestClass'.
	browser followEntity: entityToSelect.

	self assert: browser miSelectedItem equals: entityToSelect
]
