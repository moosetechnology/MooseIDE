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

	{ 
		MiInspectCommand.
		MiPropagateCommand } do: [ :cmdClass | 
		self deny: (self actionButton: cmdClass) isEnabled ].
	self assert: (self actionButton: MiDragWindowCommand) isEnabled.

	browser receiveEntity: (FamixStClass named: 'TestClass').

	{ 
		MiInspectCommand.
		MiPropagateCommand.
		MiDragWindowCommand } do: [ :cmdClass | 
		self assert: (self actionButton: cmdClass) isEnabled ]
]

{ #category : #tests }
MiTreeMapVisualisationBrowserTest >> testMiSelectedItem [

	| entityToSelect |
	self assert: browser miSelectedItem isNil.

	entityToSelect := FamixStClass named: 'TestClass'.
	browser receiveEntity: entityToSelect.

	self assert: browser miSelectedItem equals: entityToSelect
]
