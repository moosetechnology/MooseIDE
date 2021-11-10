Class {
	#name : #MiTreeMapVisualisationBrowserTest,
	#superclass : #MiAbstractBrowserTest,
	#category : #'MooseIDE-Tests-Browsers'
}

{ #category : #running }
MiTreeMapVisualisationBrowserTest >> browserClass [
	^ MiTreeMapVisualisationBrowser
]

{ #category : #tests }
MiTreeMapVisualisationBrowserTest >> testActivateActionButtons [
	{ MiInspectCommand . MiPropagateCommand . MiDragWindowCommand }
	do: [ :cmdClass | self deny: (self actionButton: cmdClass) isEnabled ].

	browser selectEntity: (FamixStClass named: 'TestClass').

	{ MiInspectCommand . MiPropagateCommand }
	do: [ :cmdClass | self assert: (self actionButton: cmdClass) isEnabled ].
	self deny: (self actionButton: MiDragWindowCommand) isEnabled.

]

{ #category : #tests }
MiTreeMapVisualisationBrowserTest >> testMiSelectedItem [

	| entityToSelect |
	self assert: browser miSelectedItem isNil.

	entityToSelect := FamixStClass named: 'TestClass'.
	browser followEntity: entityToSelect.

	self assert: browser miSelectedItem equals: entityToSelect
]
