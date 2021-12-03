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

	browser actionButtons do: [ :button | self deny: button isEnabled ].

	browser selectEntity: entityToSelect.
	browser actionButtons do: [ :button | self assert: button isEnabled ]
]

{ #category : #tests }
MiFilesBrowserTest >> testMiSelectedItem [

	browser selectEntity: entityToSelect.
	self assert: browser miSelectedItem equals: entityToSelect
]
