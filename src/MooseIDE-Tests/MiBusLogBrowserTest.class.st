Class {
	#name : #MiBusLogBrowserTest,
	#superclass : #MiAbstractBrowserTest,
	#instVars : [
		'newBrowser',
		'entityToSelect'
	],
	#category : #'MooseIDE-Tests-Browsers'
}

{ #category : #running }
MiBusLogBrowserTest >> browserClass [

	^ MiBusLogBrowser
]

{ #category : #initialization }
MiBusLogBrowserTest >> setUp [

	super setUp.
	entityToSelect := FamixStClass named: 'TestClass'
]

{ #category : #running }
MiBusLogBrowserTest >> tearDown [

	newBrowser ifNotNil: [ newBrowser window close ].
	super tearDown
]

{ #category : #tests }
MiBusLogBrowserTest >> testActivateActionButtons [
	{ MiInspectCommand . MiPropagateCommand . MiDragWindowCommand }
	do: [ :cmdClass | self deny: (self actionButton: cmdClass) isEnabled ].

	self bus globallySelect: entityToSelect.
	{ MiInspectCommand . MiPropagateCommand }
	do: [ :cmdClass | self assert: (self actionButton: cmdClass) isEnabled ].
	self deny: (self actionButton: MiDragWindowCommand) isEnabled.

]

{ #category : #tests }
MiBusLogBrowserTest >> testActivateLocalActionButtons [

	browser localActionButtons do: [ :button | self deny: button isEnabled ].
	
	self bus globallySelect: entityToSelect.
	browser localActionButtons do: [ :button | self assert: button isEnabled ]
]

{ #category : #tests }
MiBusLogBrowserTest >> testMiSelectedItem [

	self assert: browser miSelectedItem isNil.

	self bus globallySelect: entityToSelect.

	self assert: browser miSelectedItem equals: entityToSelect
]

{ #category : #running }
MiBusLogBrowserTest >> testOpenOnLatestEntity [

	self assert: browser miSelectedItem isNil.

	self bus globallySelect: entityToSelect.

	newBrowser := self browserClass openForTests.
	self assert: newBrowser miSelectedItem equals: entityToSelect
]
