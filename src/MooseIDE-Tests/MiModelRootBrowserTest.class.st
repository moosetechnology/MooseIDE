Class {
	#name : #MiModelRootBrowserTest,
	#superclass : #MiAbstractBrowserTest,
	#instVars : [
		'savedRoot'
	],
	#category : #'MooseIDE-Tests-Browsers'
}

{ #category : #running }
MiModelRootBrowserTest >> browserClass [
	^ MiModelRootBrowser
]

{ #category : #running }
MiModelRootBrowserTest >> setUp [

	savedRoot := MooseModelRoot installedRoot.
	MooseModelRoot resetRoot.
	super setUp
]

{ #category : #running }
MiModelRootBrowserTest >> tearDown [

	MooseModelRoot installRoot: savedRoot.
	super tearDown
]

{ #category : #tests }
MiModelRootBrowserTest >> testActivateActionButtons [
	| newModel |
	{ MiInspectCommand . MiPropagateCommand }
	do: [ :cmdClass | self deny: (self actionButton: cmdClass) isEnabled ].
	self assert: (self actionButton: MiDragWindowCommand) isEnabled.

	newModel := MooseModel new.
	MooseModel root add: newModel.
	browser updateForNewModel: newModel.

	{ MiInspectCommand . MiPropagateCommand . MiDragWindowCommand }
	do: [ :cmdClass | self assert: (self actionButton: cmdClass) isEnabled ].

]

{ #category : #tests }
MiModelRootBrowserTest >> testMiSelectedItem [

	| newModel |
	self assert: browser miSelectedItem isNil.

	newModel := MooseModel new.
	MooseModel root add: newModel.
	browser updateForNewModel: newModel.

	self assert: browser miSelectedItem equals: newModel
]
