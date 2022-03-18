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

	browser receiveEntity: (FamixStClass named: 'TestClass').

	{ MiInspectCommand . MiPropagateCommand . MiDragWindowCommand }
	do: [ :cmdClass | self assert: (self actionButton: cmdClass) isEnabled ].
]

{ #category : #tests }
MiExportBrowserTest >> testMiSelectedItem [

	| entityToSelect groupToSelect |
	"Empty: MiSelectedItem is an empty mooseGroup"
	self assert: browser miSelectedItem isEmpty.

	entityToSelect := FamixStClass named: 'TestClass'.
	browser followEntity: entityToSelect.
	"Only 1 entity: miSelectedItem is this entity."
	self assert: browser miSelectedItem equals: entityToSelect.

	groupToSelect := { 
		                 (FamixStClass named: 'TestClass1').
		                 (FamixStClass named: 'TestClass2') }
		                 asMooseSpecializedGroup.
	browser followEntity: groupToSelect.
	"Group of entities: miSelectedItem is this group"
	self assert: browser miSelectedItem class equals: FamixClassGroup.
	self
		assertCollection: browser miSelectedItem
		hasSameElements: groupToSelect
]
