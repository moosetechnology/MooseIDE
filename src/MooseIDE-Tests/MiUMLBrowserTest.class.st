Class {
	#name : #MiUMLBrowserTest,
	#superclass : #MiAbstractBrowserTest,
	#category : #'MooseIDE-Tests-Browsers'
}

{ #category : #running }
MiUMLBrowserTest >> browserClass [
	^ MiUMLBrowser
]

{ #category : #tests }
MiUMLBrowserTest >> testCanTagEntities [
	self deny: browser canTagEntities 
]

{ #category : #tests }
MiUMLBrowserTest >> testMiSelectedItem [

	| entityToSelect |
	self assert: browser miSelectedItem isNil.

	entityToSelect := FamixStClass named: 'TestClass'.
	browser followEntity: entityToSelect.

	self assert: browser miSelectedItem size equals: 1.
	self assert: browser miSelectedItem anyOne equals: entityToSelect
]
