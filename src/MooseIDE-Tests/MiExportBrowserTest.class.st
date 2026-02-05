Class {
	#name : 'MiExportBrowserTest',
	#superclass : 'MiAbstractBrowserTest',
	#category : 'MooseIDE-Tests-Browsers',
	#package : 'MooseIDE-Tests',
	#tag : 'Browsers'
}

{ #category : 'running' }
MiExportBrowserTest >> browserClass [

	^ MiExportBrowser
]

{ #category : 'tests' }
MiExportBrowserTest >> testMiSelectedItem [

	| entityToSelect |
	self assert: browser miSelectedItem isEmpty.

	entityToSelect := FamixRepTestClass named: 'TestClass'.
	browser followEntity: entityToSelect.

	self assert: browser miSelectedItem size equals: 1.
	self assert: browser miSelectedItem anyOne equals: entityToSelect
]

{ #category : 'tests - receiving' }
MiExportBrowserTest >> testPropagateToOtherBrowser [
	"overriding because here we have 2 MiExportBrowser"

	self receiveEntityToSelect.
	
	browser canPropagate ifFalse: [ self skip ].

	browser propagateToOtherBrowser: MiExportBrowser.
	
	otherBrowser := browser application browsers
		detect: [ :br | (br class = MiExportBrowser) and: [ br ~= browser ] ]
		ifNone: [ nil ].

	self assert: otherBrowser isNotNil.
	
	browser miSelectedItemToPropagate isCollection 
		ifTrue: [
			self
				assertCollection: otherBrowser miSelectedItem
				hasSameElements: browser miSelectedItemToPropagate
		]
		ifFalse: [
			self assert: otherBrowser miSelectedItem size equals: 1.
			self assert: otherBrowser miSelectedItem anyOne equals: browser miSelectedItemToPropagate
		]

]

{ #category : 'tests - tags' }
MiExportBrowserTest >> testSelectedTagSetAndGet [
	| model entity tag |
	model := FamixRepTestModel new.
	tag := model tagNamed: 'aTag'.
	entity := FamixRepTestClass new name: 'aClass' ; mooseModel: model ; yourself.

	browser followEntity: entity.
	browser selectedTag: tag.
	self assert: browser selectedTag equals: tag
]
