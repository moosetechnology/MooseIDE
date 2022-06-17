Class {
	#name : #MiDependencyBrowserTest,
	#superclass : #MiAbstractBrowserTest,
	#instVars : [
		'entityToSelect'
	],
	#category : #'MooseIDE-Tests-Browsers'
}

{ #category : #running }
MiDependencyBrowserTest >> browserClass [
	^ MiDependencyBrowser
]

{ #category : #running }
MiDependencyBrowserTest >> setUp [

	super setUp.
	entityToSelect := FamixStClass named: 'TestClass'
]

{ #category : #tests }
MiDependencyBrowserTest >> testActivateActionButtons [

	{ 
		MiInspectCommand.
		MiPropagateCommand } do: [ :cmdClass | 
		self deny: (self actionButton: cmdClass) isEnabled ].
	self assert: (self actionButton: MiDragWindowCommand) isEnabled.

	browser receiveEntity: (MooseGroup with: entityToSelect).
	{ 
		MiInspectCommand.
		MiPropagateCommand.
		MiDragWindowCommand } do: [ :cmdClass | 
		self assert: (self actionButton: cmdClass) isEnabled ].


	browser containedBrowser diagram canvas shapes anyOne click.
	{ 
		MiInspectCommand.
		MiPropagateCommand.
		MiDragWindowCommand } do: [ :cmdClass | 
		self assert: (self actionButton: cmdClass) isEnabled ]
]

{ #category : #tests }
MiDependencyBrowserTest >> testMiSelectedItem [

	self assert: browser miSelectedItem isMooseObject.

	browser receiveEntity: (MooseGroup with: entityToSelect).
	self assert: browser miSelectedItem isMooseObject.
	self assert: browser miSelectedItem anyOne equals: entityToSelect.

	browser containedBrowser diagram canvas shapes anyOne click.
	self assert: browser miSelectedItem equals: entityToSelect
]
