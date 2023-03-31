Class {
	#name : #MiDependencyBrowserTest,
	#superclass : #MiAbstractBrowserTest,
	#instVars : [
		'entityToSelect'
	],
	#category : #'MooseIDE-Tests-Browsers'
}

{ #category : #running }
MiDependencyBrowserTest >> browserClass [
	^ MiDependencyBrowser
]

{ #category : #running }
MiDependencyBrowserTest >> setUp [

	super setUp.
	entityToSelect := FamixStClass named: 'TestClass'
]

{ #category : #tests }
MiDependencyBrowserTest >> testActivateActionButtons [

	browser actionButtons do: [ :button | self deny: button isEnabled ].

	browser receiveEntity: (MooseGroup with: entityToSelect).
	browser actionButtons do: [ :button | self assert: button isEnabled ].

	browser diagram canvas shapes anyOne click.
	browser actionButtons do: [ :button | self assert: button isEnabled ]
]

{ #category : #tests }
MiDependencyBrowserTest >> testCanTagEntities [
	self deny: browser canTagEntities 
]

{ #category : #tests }
MiDependencyBrowserTest >> testMiSelectedItem [

	self assert: browser miSelectedItem isMooseObject.

	browser receiveEntity: (MooseGroup with: entityToSelect).
	self assert: browser miSelectedItem isMooseObject.
	self assert: browser miSelectedItem anyOne equals: entityToSelect.

	browser diagram canvas shapes anyOne click.
	self assert: browser miSelectedItem equals: entityToSelect
]
