Class {
	#name : #MiCBRuleComponentBuilderPresenterTest,
	#superclass : #MiAbstractApplicationTest,
	#instVars : [
		'browser',
		'contextBuilder'
	],
	#category : #'MooseIDE-CriticBrowser-Tests'
}

{ #category : #testing }
MiCBRuleComponentBuilderPresenterTest class >> isAbstract [

	^ self == MiCBRuleComponentBuilderPresenterTest
]

{ #category : #tests }
MiCBRuleComponentBuilderPresenterTest >> builderCodeInputField [

	^ contextBuilder presenterAt: #codeInputField
]

{ #category : #tests }
MiCBRuleComponentBuilderPresenterTest >> builderSummaryField [

	^ contextBuilder presenterAt: #summaryField
]

{ #category : #accessing }
MiCBRuleComponentBuilderPresenterTest >> builderTitleField [

	^ contextBuilder presenterAt: #titleField
]

{ #category : #running }
MiCBRuleComponentBuilderPresenterTest >> otherComponent [

	self subclassResponsibility
]

{ #category : #running }
MiCBRuleComponentBuilderPresenterTest >> ruleComponentToEdit [

	self subclassResponsibility
]

{ #category : #running }
MiCBRuleComponentBuilderPresenterTest >> setUp [

	super setUp.
	browser := MiCriticBrowser openForTests: self application.
	(browser presenterAt: #rules) selectPath: { 1 }
]

{ #category : #running }
MiCBRuleComponentBuilderPresenterTest >> setUpBuilderAsCreator [

	contextBuilder := self toolClass on: browser specModel
]

{ #category : #running }
MiCBRuleComponentBuilderPresenterTest >> setUpBuilderAsEditor [

	| contextToEdit |
	contextToEdit := self ruleComponentToEdit.

	browser specModel addChildToRootContext: contextToEdit.
	browser updateRulesList.

	(browser presenterAt: #rules) selectItem: contextToEdit.

	contextBuilder := (self toolClass on: browser specModel)
		                  beForEdition;
		                  yourself
]

{ #category : #running }
MiCBRuleComponentBuilderPresenterTest >> tearDown [

	browser ifNotNil: [ browser withWindowDo: [ :window | window close ] ].
	super tearDown
]

{ #category : #tests }
MiCBRuleComponentBuilderPresenterTest >> testAddNewComponent [

	self setUpBuilderAsCreator.

	self builderTitleField text: 'test'.
	self builderCodeInputField text: self otherComponent printAsBlock.

	contextBuilder addNewComponent.

	self assert: browser specModel rootContext children size equals: 1.
	self
		assert: browser specModel rootContext children anyOne name
		equals: 'test'
]

{ #category : #tests }
MiCBRuleComponentBuilderPresenterTest >> testEditComponent [

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
MiCBRuleComponentBuilderPresenterTest >> testFillWithRuleComponent [

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
MiCBRuleComponentBuilderPresenterTest >> toolClass [

	self subclassResponsibility
]
