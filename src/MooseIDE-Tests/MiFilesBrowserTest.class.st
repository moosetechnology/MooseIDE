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

{ #category : #tests }
MiFilesBrowserTest >> setEntityToSelect [ 
		browser receiveEntity: entityToSelect.
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
MiFilesBrowserTest >> testCanTagEntities [
	self deny: browser canTagEntities 
]

{ #category : #tests }
MiFilesBrowserTest >> testMiSelectedItem [

	browser receiveEntity: entityToSelect.
	self assert: browser miSelectedItem equals: entityToSelect
]
