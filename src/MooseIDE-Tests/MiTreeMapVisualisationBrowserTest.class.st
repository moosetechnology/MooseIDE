Class {
	#name : #MiTreeMapVisualisationBrowserTest,
	#superclass : #MiAbstractBrowserTest,
	#category : #'MooseIDE-Tests-Browsers'
}

{ #category : #running }
MiTreeMapVisualisationBrowserTest >> browserClass [
	^ MiTreeMapVisualisationBrowser
]

{ #category : #tests }
MiTreeMapVisualisationBrowserTest >> testActivateActionButtons [

	browser actionButtons do: [ :button | self deny: button isEnabled ].

	browser receiveEntity: (FamixStClass named: 'TestClass').

	browser actionButtons do: [ :button | self assert: button isEnabled ]
]

{ #category : #tests }
MiTreeMapVisualisationBrowserTest >> testMiSelectedItem [

	| entityToSelect |
	self assert: browser miSelectedItem isNil.

	entityToSelect := FamixRepTestClass named: 'TestClass'.
	browser receiveEntity: entityToSelect.

	self assert: browser miSelectedItem equals: entityToSelect
]

{ #category : #'tests - tags' }
MiTreeMapVisualisationBrowserTest >> testSelectedTagSetAndGet [
	| model entity tag |
	model := FamixRepTestModel new.
	tag := model tagNamed: 'aTag'.
	entity := FamixRepTestClass new name: 'aClass' ; mooseModel: model ; yourself.

	browser followEntity: entity.
	browser selectedTag: tag.
	self assert: browser selectedTag equals: tag
]
