Class {
	#name : #MiExportBrowserTest,
	#superclass : #MiAbstractBrowserTest,
	#category : #'MooseIDE-Tests-Browsers'
}

{ #category : #running }
MiExportBrowserTest >> browserClass [

	^ MiExportBrowser
]

{ #category : #tests }
MiExportBrowserTest >> testActivateActionButtons [

	browser actionButtons do: [ :button | self deny: button isEnabled ].

	browser receiveEntity: (FamixStClass named: 'TestClass').

	browser actionButtons do: [ :button | self assert: button isEnabled ]
]

{ #category : #tests }
MiExportBrowserTest >> testMiSelectedItem [

	| entityToSelect |
	self assert: browser miSelectedItem isEmpty.

	entityToSelect := FamixRepTestClass named: 'TestClass'.
	browser followEntity: entityToSelect.

	self assert: browser miSelectedItem size equals: 1.
	self assert: browser miSelectedItem anyOne equals: entityToSelect
]

{ #category : #'tests - tags' }
MiExportBrowserTest >> testTagSelectedSetAndGet [
	| model entity tag |
	model := FamixRepTestModel new.
	tag := model tagNamed: 'aTag'.
	entity := FamixRepTestClass new name: 'aClass' ; mooseModel: model ; yourself.

	browser followEntity: entity.
	browser tagSelected: tag.
	self assert: browser tagSelected equals: tag
]
