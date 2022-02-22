Class {
	#name : #MiFameBrowserTest,
	#superclass : #MiAbstractBrowserTest,
	#instVars : [
		'entityToSelect'
	],
	#category : #'MooseIDE-Tests-Browsers'
}

{ #category : #running }
MiFameBrowserTest >> browserClass [
	^ MiFameBrowser
]

{ #category : #initialization }
MiFameBrowserTest >> setUp [

	super setUp.
	entityToSelect := FamixStClass named: 'TestClass'
]

{ #category : #tests }
MiFameBrowserTest >> testActivateActionButtons [

	{ MiInspectCommand . MiPropagateCommand }
	do: [ :cmdClass | self deny: (self actionButton: cmdClass) isEnabled ].
	self assert: (self actionButton: MiDragWindowCommand) isEnabled.

	browser receiveEntity: entityToSelect.
	{ MiInspectCommand . MiPropagateCommand . MiDragWindowCommand }
	do: [ :cmdClass | self assert: (self actionButton: cmdClass) isEnabled ].

]

{ #category : #'tests - opening' }
MiFameBrowserTest >> testBrowserFollowsPrivatelBus [

	self assert: browser containedBrowser privateBus equals: browser privateBus
]

{ #category : #tests }
MiFameBrowserTest >> testMiSelectedItem [

	self should: [browser miSelectedItem] raise: MiNoSelectedElementToPropagateException.

	browser receiveEntity: entityToSelect.
	self assert: browser miSelectedItem equals: entityToSelect
]
