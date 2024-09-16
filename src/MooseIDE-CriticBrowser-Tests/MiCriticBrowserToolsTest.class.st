Class {
	#name : #MiCriticBrowserToolsTest,
	#superclass : #MiAbstractApplicationTest,
	#instVars : [
		'browser',
		'contextBuilder'
	],
	#category : #'MooseIDE-CriticBrowser-Tests'
}

{ #category : #testing }
MiCriticBrowserToolsTest class >> isAbstract [

	^ self == MiCriticBrowserToolsTest
]

{ #category : #tests }
MiCriticBrowserToolsTest >> builderCodeInputField [

	^ contextBuilder presenterAt: #codeInputField
]

{ #category : #tests }
MiCriticBrowserToolsTest >> builderSummaryField [

	^ contextBuilder presenterAt: #summaryField
]

{ #category : #accessing }
MiCriticBrowserToolsTest >> builderTitleField [

	^ contextBuilder presenterAt: #titleField
]

{ #category : #running }
MiCriticBrowserToolsTest >> otherComponent [

	self subclassResponsibility
]

{ #category : #running }
MiCriticBrowserToolsTest >> ruleComponentToEdit [

	self subclassResponsibility
]

{ #category : #running }
MiCriticBrowserToolsTest >> setUp [

	super setUp.
	browser := MiCriticBrowser openForTests: self application.
	(browser presenterAt: #rules) selectPath: { 1 }
]

{ #category : #running }
MiCriticBrowserToolsTest >> setUpBuilderAsCreator [

	contextBuilder := self toolClass on: browser model
]

{ #category : #running }
MiCriticBrowserToolsTest >> setUpBuilderAsEditor [

	| contextToEdit |
	contextToEdit := self ruleComponentToEdit.

	browser model addChildToRootContext: contextToEdit.
	browser updateRulesList.

	(browser presenterAt: #rules) selectItem: contextToEdit.

	contextBuilder := (self toolClass on: browser model)
		                        beForEdition;
		                        yourself
]

{ #category : #running }
MiCriticBrowserToolsTest >> tearDown [

	browser ifNotNil: [ browser withWindowDo: [ :window | window close ] ].
	super tearDown
]

{ #category : #tests }
MiCriticBrowserToolsTest >> testAddInputtedCodeRule [

	self setUpBuilderAsCreator.

	self builderTitleField text: 'test'.
	self builderCodeInputField text: self otherComponent printAsBlock.

	contextBuilder addNewComponent.

	self assert: browser model rootContext children size equals: 1.
	self
		assert: browser model rootContext children anyOne name
		equals: 'test'
]

{ #category : #tests }
MiCriticBrowserToolsTest >> testEditComponent [

	| componentToEdit otherComponent |
	self setUpBuilderAsEditor.

	otherComponent := self otherComponent.

	self builderTitleField text: otherComponent name.
	self builderCodeInputField text: otherComponent printAsBlock.
	self builderSummaryField text: otherComponent summary.

	componentToEdit := browser selectedRule.
	contextBuilder editComponent.

	self assert: componentToEdit name equals: otherComponent name.
	self
		assert: componentToEdit printAsBlock
		equals: otherComponent printAsBlock.
	self assert: componentToEdit summary equals: otherComponent summary
]

{ #category : #tests }
MiCriticBrowserToolsTest >> testFillComponentToEdit [

	| component |
	self setUpBuilderAsCreator.

	component := self ruleComponentToEdit.

	contextBuilder fillWithRuleComponent: component.
	self assert: self builderTitleField text equals: component name.
	self
		assert: self builderCodeInputField text
		equals: component printAsBlock.
	self assert: self builderSummaryField text equals: component summary
]

{ #category : #accessing }
MiCriticBrowserToolsTest >> toolClass [

	self subclassResponsibility
]
