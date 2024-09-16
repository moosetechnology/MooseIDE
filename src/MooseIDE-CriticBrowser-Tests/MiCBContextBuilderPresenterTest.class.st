"
A MiCriticBrowserContextMakerPresenterTest is a test class for testing the behavior of MiCriticBrowserContextMakerPresenter
"
Class {
	#name : #MiCBContextBuilderPresenterTest,
	#superclass : #MiCriticBrowserToolsTest,
	#category : #'MooseIDE-CriticBrowser-Tests'
}

{ #category : #running }
MiCBContextBuilderPresenterTest >> ruleComponentToEdit [

	^ FamixCBContext
		  named: 'test'
		  on: '[ :col | col ]'
		  summary: 'règle utilisée pour un test'
]

{ #category : #tests }
MiCBContextBuilderPresenterTest >> testAddInputtedCodeRule [

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
MiCBContextBuilderPresenterTest >> testEditContext [

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
MiCBContextBuilderPresenterTest >> testFillContextToEdit [

	| context |
	self setUpBuilderAsCreator.

	context := self ruleComponentToEdit.

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

{ #category : #accessing }
MiCBContextBuilderPresenterTest >> toolClass [

	^ MiCBContextBuilderPresenter
]
