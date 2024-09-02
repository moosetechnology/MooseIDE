Class {
	#name : #MiFilesBrowserTest,
	#superclass : #MiAbstractBrowserTest,
	#category : #'MooseIDE-Tests-Browsers'
}

{ #category : #running }
MiFilesBrowserTest >> browserClass [
	^ MiFilesBrowser
]

{ #category : #running }
MiFilesBrowserTest >> initializeEntityToSelect [

	^ entityToSelect:= MooseModel new
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

	self receiveEntityToSelect.
	self assert: browser miSelectedItem equals: self entityToSelect
]
