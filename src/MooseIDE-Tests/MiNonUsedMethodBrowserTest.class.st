Class {
	#name : #MiNonUsedMethodBrowserTest,
	#superclass : #MiAbstractBrowserTest,
	#category : #'MooseIDE-Tests-Browsers'
}

{ #category : #running }
MiNonUsedMethodBrowserTest >> browserClass [
	^ MiNonUsedMethodBrowser
]

{ #category : #tests }
MiNonUsedMethodBrowserTest >> testMiActivateActionButtons [

	| entityToSelect |
	browser actionButtons do: [ :button | self deny: button isEnabled ].

	entityToSelect := (FamixStClass named: 'TestClass')
		                  addMethod: (FamixStMethod named: 'TestMethod');
		                  yourself.
	browser followEntity: entityToSelect.

	browser actionButtons do: [ :button | self assert: button isEnabled ]
]

{ #category : #tests }
MiNonUsedMethodBrowserTest >> testMiSelectedItem [

	| entityToSelect |
	self assert: browser miSelectedItem isEmpty.
	entityToSelect := (FamixStClass named: 'TestClass')
		                  addMethod: (FamixStMethod named: 'TestMethod');
		                  yourself.
	browser followEntity: entityToSelect.
	self
		assertCollection: browser miSelectedItem
		hasSameElements: entityToSelect methods
]
