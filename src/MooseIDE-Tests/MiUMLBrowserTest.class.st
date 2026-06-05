Class {
	#name : 'MiUMLBrowserTest',
	#superclass : 'MiAbstractBrowserTest',
	#category : 'MooseIDE-Tests-Browsers',
	#package : 'MooseIDE-Tests',
	#tag : 'Browsers'
}

{ #category : 'running' }
MiUMLBrowserTest >> browserClass [
	^ MiUMLBrowser
]

{ #category : 'running' }
MiUMLBrowserTest >> browserVisualization [

	^browser instVarNamed: #mainPresenter
]

{ #category : 'tests' }
MiUMLBrowserTest >> testCanTagEntities [
	self deny: browser canTagEntities 
]

{ #category : 'tests' }
MiUMLBrowserTest >> testMiSelectedItem [

	self assert: browser miSelectedItem isNil.

	entityToSelect := FamixStClass named: 'TestClass'.
	browser followEntity: entityToSelect.

	self assert: browser miSelectedItem size equals: 1.
	self assert: browser miSelectedItem anyOne equals: entityToSelect
]

{ #category : 'tests' }
MiUMLBrowserTest >> testMiSelectedItemWithSelection [
	"returns selected entities"
	| map entity1 entity2 entity3 |
	entity1 := FamixStClass new name: 'class1' ; yourself.
	entity2 := FamixStClass new name: 'class2' ; yourself.
	entity3 := FamixStClass new name: 'class3' ; yourself.

	map := self browserVisualization.
	
	browser followEntity: { entity1 . entity2 . entity3 }.
	map canvas selectedShapes: { map shapeFromEntity: entity1 . map shapeFromEntity: entity3 }.
	
	self assertCollection: browser miSelectedItem hasSameElements:   { entity1 . entity3 }.
	
]

{ #category : 'tests' }
MiUMLBrowserTest >> testSettingsAction [

	self assert: browser hasSettings
]
