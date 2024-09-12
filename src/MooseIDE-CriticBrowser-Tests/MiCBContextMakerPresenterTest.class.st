"
A MiCriticBrowserContextMakerPresenterTest is a test class for testing the behavior of MiCriticBrowserContextMakerPresenter
"
Class {
	#name : #MiCBContextMakerPresenterTest,
	#superclass : #MiCriticBrowserToolsTest,
	#instVars : [
		'contextBuilder'
	],
	#category : #'MooseIDE-CriticBrowser-Tests'
}

{ #category : #accessing }
MiCBContextMakerPresenterTest >> contextBuilderClass [

	^ MiCBContextMakerPresenter
]

{ #category : #running }
MiCBContextMakerPresenterTest >> contextToEdit [

	^ FamixCBContext
		  named: 'test'
		  on: '[ :col | col ]'
		  summary: 'règle utilisée pour un test'
]

{ #category : #running }
MiCBContextMakerPresenterTest >> setUp [

	super setUp.

	(browser presenterAt: #rules) selectPath: { 1 }
]

{ #category : #running }
MiCBContextMakerPresenterTest >> setUpBuilderAsCreator [

	contextBuilder := self contextBuilderClass on: browser model
]

{ #category : #running }
MiCBContextMakerPresenterTest >> setUpBuilderAsEditor [

	| contextToEdit |
	contextToEdit := self contextToEdit.

	browser model addChildToRootContext: contextToEdit.
	browser updateRulesList.

	(browser presenterAt: #rules) selectItem: contextToEdit.

	contextBuilder := (self contextBuilderClass on: browser model)
		                        beForEdition;
		                        yourself
]

{ #category : #tests }
MiCBContextMakerPresenterTest >> testAddInputtedCodeRule [

	self setUpBuilderAsCreator.

	(contextBuilder presenterAt: #contextTitle) text: 'test'.
	(contextBuilder presenterAt: #codeInput) text:
		'[ :col | col allClasses ]'.

	contextBuilder addNewContext.

	self assert: browser model rootContext children size equals: 1.
	self
		assert: browser model rootContext children anyOne name
		equals: 'test'
]

{ #category : #tests }
MiCBContextMakerPresenterTest >> testEditContext [

	| contextToEdit newTitle newBlock newSummary |
	self setUpBuilderAsEditor.
	contextToEdit := browser selectedRule.

	newTitle := 'test édité'.
	newBlock := '[ :col | col allClasses ]'.
	newSummary := 'contexte modifié pour un test'.

	contextBuilder contextTitle text: newTitle.
	contextBuilder codeInput text: newBlock.
	contextBuilder contextSummary text: newSummary.

	contextBuilder editContext.

	self assert: contextToEdit name equals: newTitle.
	self assert: contextToEdit contextBlock asString equals: newBlock.
	self assert: contextToEdit summary equals: newSummary
]

{ #category : #tests }
MiCBContextMakerPresenterTest >> testFillContextToEdit [

	| context |
	self setUpBuilderAsCreator.

	context := self contextToEdit.

	contextBuilder fillWithContext: context.
	self
		assert: (contextBuilder presenterAt: #contextTitle) text
		equals: context name.
	self
		assert: (contextBuilder presenterAt: #codeInput) text
		equals: context contextBlock asString.
	self
		assert: (contextBuilder presenterAt: #contextSummary) text
		equals: context summary
]
