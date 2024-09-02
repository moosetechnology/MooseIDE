"
A MiCriticBrowserContextMakerPresenterTest is a test class for testing the behavior of MiCriticBrowserContextMakerPresenter
"
Class {
	#name : #MiCBContextMakerPresenterTest,
	#superclass : #MiCriticBrowserToolsTest,
	#instVars : [
		'editContextPresenter',
		'addContextsPresenter'
	],
	#category : #'MooseIDE-CriticBrowser-Tests'
}

{ #category : #running }
MiCBContextMakerPresenterTest >> setUp [

	super setUp.
	browser addContextsPresenter setParentContext:
		browser model rootContext.
	addContextsPresenter := browser addContextsPresenter contextPresenter.
	editContextPresenter := browser contextEditorPresenter
		                        contextPresenter.
	browser addContextsPresenter openDialog
]

{ #category : #running }
MiCBContextMakerPresenterTest >> tearDown [

	browser addContextsPresenter withWindowDo: [ :window | window close ].
	super tearDown
]

{ #category : #tests }
MiCBContextMakerPresenterTest >> testAddInputtedCodeRule [

	addContextsPresenter contextTitle text: 'test'.
	addContextsPresenter codeInput text: '[ :col | col allClasses ]'.
	addContextsPresenter addButtonAction.

	self assert: browser model rootContext children size equals: 1.
	self
		assert: browser model rootContext children anyOne name
		equals: 'test'
]

{ #category : #tests }
MiCBContextMakerPresenterTest >> testEditContext [
	| context newTitle newBlock newSummary |
	context := FamixCBContext named: 'test' on: '[ :col | col ]' summary: 'règle utilisée pour un test'.
	newTitle := 'test édité'.
	newBlock := '[ :col | col allClasses ]'.
	newSummary := 'contexte modifié pour un test'.
	
	editContextPresenter fillContextToEdit: context.
	editContextPresenter contextTitle text: newTitle.
	editContextPresenter codeInput text: newBlock.
	editContextPresenter contextSummary text: newSummary.
	editContextPresenter editContext: context.
	self assert: context name equals: newTitle.
	self assert: context contextBlock asString equals: newBlock.
	self assert: context summary equals: newSummary
]

{ #category : #tests }
MiCBContextMakerPresenterTest >> testFillContextToEdit [
	| context |
	context := FamixCBContext named: 'test' on: '[ :col | col ]' summary: 'règle utilisée pour un test'.
	
	addContextsPresenter fillContextToEdit: context.
	self assert: addContextsPresenter contextTitle text equals: context name.
	self assert: addContextsPresenter codeInput text equals: context contextBlock asString.
	self assert: addContextsPresenter contextSummary text equals: context summary.
]
