Class {
	#name : #MiFilesBrowserTest,
	#superclass : #MiAbstractBrowserTest,
	#instVars : [
		'entityToSelect'
	],
	#category : #'MooseIDE-Tests-Browsers'
}

{ #category : #running }
MiFilesBrowserTest >> browserClass [
	^ MiFilesBrowser
]

{ #category : #initialization }
MiFilesBrowserTest >> setUp [

	super setUp.
	entityToSelect := MooseModel new
		                  rootFolder: FileSystem workingDirectory;
		                  add: MooseEntity new;
		                  yourself
]

{ #category : #tests }
MiFilesBrowserTest >> testActivateActionButtons [
	{ MiInspectCommand . MiPropagateCommand }
	do: [ :cmdClass | self deny: (self actionButton: cmdClass) isEnabled ].
	self assert: (self actionButton: MiDragWindowCommand) isEnabled.

	browser receiveEntity: entityToSelect.
	{ MiInspectCommand . MiPropagateCommand . MiDragWindowCommand }
	do: [ :cmdClass | self assert: (self actionButton: cmdClass) isEnabled ].

]

{ #category : #tests }
MiFilesBrowserTest >> testMiSelectedItem [

	browser receiveEntity: entityToSelect.
	self assert: browser miSelectedItem equals: entityToSelect
]
