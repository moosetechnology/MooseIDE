"
A MiCriticBrowserQueryMakerPresenterTest is a test class for testing the behavior of MiCriticBrowserQueryMakerPresenter
"
Class {
	#name : #MiCBConditionBuilderPresenterTest,
	#superclass : #MiCriticBrowserToolsTest,
	#instVars : [
		'addQueryPresenter',
		'editQueryPresenter'
	],
	#category : #'MooseIDE-CriticBrowser-Tests'
}

{ #category : #tests }
MiCBConditionBuilderPresenterTest >> conditionWithQuery [

	^ FamixCBCondition
		  named: 'test2'
		  on: (FamixCBQueryHandler on: (FQBooleanQuery property: #isDead))
		  summary: 'autre règle utilisée pour un test'
]

{ #category : #tests }
MiCBConditionBuilderPresenterTest >> ruleComponentToEdit [

	^ FamixCBCondition
		  named: 'test'
		  on: (FamixCBScriptQueryHandler on: '[ :entity | entity isStub ]')
		  summary: 'règle utilisée pour un test'
]

{ #category : #tests }
MiCBConditionBuilderPresenterTest >> testAddInputtedCodeRule [

	self setUpBuilderAsCreator.

	(contextBuilder presenterAt: #conditionTitle) text: 'test'.
	contextBuilder codeInput text: '[ :entity | entity isDead ]'.
	contextBuilder addNewCondition.

	self assert: browser model rootContext children size equals: 1.
	self
		assert: browser model rootContext children anyOne name
		equals: 'test'
]

{ #category : #tests }
MiCBConditionBuilderPresenterTest >> testAddInputtedFQRule [

	| query |
	query := FQBooleanQuery property: #isStub.

	self setUpBuilderAsCreator.

	(contextBuilder presenterAt: #queriesBrowserButton) click.
	(contextBuilder presenterAt: #conditionTitle) text: 'test'.
	(contextBuilder presenterAt: #queryDroplist)
		items: { query };
		selectItem: query.

	contextBuilder addNewCondition.

	self assert: browser model rootContext children size equals: 1.
	self
		assert: browser model rootContext children anyOne name
		equals: 'test'
]

{ #category : #tests }
MiCBConditionBuilderPresenterTest >> testEditRule [

	| conditionToEdit newTitle newQuery newSummary |
	self setUpBuilderAsEditor.
	conditionToEdit := browser selectedRule.

	newTitle := 'test édité'.
	newQuery := '[ :entity | entity isDead ]'.
	newSummary := 'règle modifiée pour un test'.

	contextBuilder conditionTitle text: newTitle.
	contextBuilder codeInput text: newQuery.
	contextBuilder conditionSummary text: newSummary.

	contextBuilder editCondition.

	self assert: conditionToEdit name equals: newTitle.
	self
		assert: conditionToEdit query asRuleEditorString
		equals: newQuery.
	self assert: conditionToEdit summary equals: newSummary
]

{ #category : #tests }
MiCBConditionBuilderPresenterTest >> testFillQueryRuleToEdit [

	| queriesBrowserRule |
	self setUpBuilderAsCreator.
	queriesBrowserRule := self conditionWithQuery.

	contextBuilder fillWithCondition: queriesBrowserRule.
	self
		assert: contextBuilder conditionTitle text
		equals: queriesBrowserRule name.
	self
		assert: contextBuilder codeInput text
		equals: '[ :entity | entity ]'.
	self
		assert: contextBuilder conditionSummary text
		equals: queriesBrowserRule summary
]

{ #category : #tests }
MiCBConditionBuilderPresenterTest >> testFillRuleToEdit [

	| rule |
	self setUpBuilderAsCreator.
	rule := self ruleComponentToEdit.

	contextBuilder fillWithCondition: rule.
	self assert: contextBuilder conditionTitle text equals: rule name.
	self
		assert: contextBuilder codeInput text
		equals: rule query asRuleEditorString.
	self
		assert: contextBuilder conditionSummary text
		equals: rule summary
]

{ #category : #accessing }
MiCBConditionBuilderPresenterTest >> toolClass [

	^ MiCBConditionBuilderPresenter
]
