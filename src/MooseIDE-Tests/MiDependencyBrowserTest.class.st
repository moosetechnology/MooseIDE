Class {
	#name : #MiDependencyBrowserTest,
	#superclass : #MiAbstractBrowserTest,
	#category : #'MooseIDE-Tests-Browsers'
}

{ #category : #running }
MiDependencyBrowserTest >> browserClass [
	^ MiDependencyBrowser
]

{ #category : #tests }
MiDependencyBrowserTest >> testMiActivateActionButtons [

	| itemToSelect |
	browser actionButtons do: [ :button | self deny: button isEnabled ].

	itemToSelect := FamixStClass named: 'TestClass'.
	browser selectEntity: (MooseGroup with: itemToSelect).
	browser actionButtons do: [ :button | self assert: button isEnabled ].

	browser diagram canvas shapes anyOne click.
	browser actionButtons do: [ :button | self assert: button isEnabled ]
]

{ #category : #tests }
MiDependencyBrowserTest >> testMiSelectedItem [

	| itemToSelect |
	self assert: browser miSelectedItem isMooseObject.

	itemToSelect := FamixStClass named: 'TestClass'.
	browser selectEntity: (MooseGroup with: itemToSelect).
	self assert: browser miSelectedItem isMooseObject.
	self assert: browser miSelectedItem anyOne equals: itemToSelect.

	browser diagram canvas shapes anyOne click.
	self assert: browser miSelectedItem equals: itemToSelect
]
