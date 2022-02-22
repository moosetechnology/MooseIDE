Class {
	#name : #MiLogsBrowserTest,
	#superclass : #MiAbstractBrowserTest,
	#instVars : [
		'entityToSelect',
		'newBrowser'
	],
	#category : #'MooseIDE-Tests-Browsers'
}

{ #category : #running }
MiLogsBrowserTest >> browserClass [

	^ MiLogsBrowser
]

{ #category : #running }
MiLogsBrowserTest >> setUp [

	super setUp.
	entityToSelect := FamixStClass named: 'TestClass'
]

{ #category : #running }
MiLogsBrowserTest >> tearDown [

	newBrowser ifNotNil: [ newBrowser window close ].
	super tearDown
]

{ #category : #tests }
MiLogsBrowserTest >> testActivateActionButtons [
	{ MiInspectCommand . MiPropagateCommand . MiDragWindowCommand }
	do: [ :cmdClass | self deny: (self actionButton: cmdClass) isEnabled ].

	self bus globallySelect: entityToSelect.
	{ MiInspectCommand . MiPropagateCommand }
	do: [ :cmdClass | self assert: (self actionButton: cmdClass) isEnabled ].
	self deny: (self actionButton: MiDragWindowCommand) isEnabled.

]

{ #category : #tests }
MiLogsBrowserTest >> testMiSelectedItem [

	self assert: browser miSelectedItem isNil.

	self bus globallySelect: entityToSelect.

	self assert: browser miSelectedItem equals: entityToSelect
]
