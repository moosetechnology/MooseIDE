"
A MiCriticBrowserQueryMakerPresenterTest is a test class for testing the behavior of MiCriticBrowserQueryMakerPresenter
"
Class {
	#name : #MiCBConditionBuilderPresenterTest,
	#superclass : #MiCBRuleComponentBuilderPresenterTest,
	#category : #'MooseIDE-CriticBrowser-Tests'
}

{ #category : #running }
MiCBConditionBuilderPresenterTest >> conditionWithQuery [

	^ FamixCBCondition
		  named: 'test2'
		  on: (FamixCBQueryHandler on: (FQBooleanQuery property: #isDead))
		  summary: 'autre règle utilisée pour un test'
]

{ #category : #running }
MiCBConditionBuilderPresenterTest >> otherComponent [

	^ FamixCBCondition
		  named: 'Test-edited'
		  on: (FamixCBScriptQueryHandler on: '[ :entity | entity isDead ]')
		  summary: 'Condition modified by tests'
]

{ #category : #running }
MiCBConditionBuilderPresenterTest >> ruleComponentToEdit [

	^ FamixCBCondition
		  named: 'Test'
		  on: (FamixCBScriptQueryHandler on: '[ :entity | entity isStub ]')
		  summary: 'Condition used in tests'
]

{ #category : #tests }
MiCBConditionBuilderPresenterTest >> testAddNewQueryCondition [

	| query |
	query := FQBooleanQuery property: #isStub.

	self setUpBuilderAsCreator.

	self builderTitleField text: 'test'.
	(contextBuilder presenterAt: #queriesBrowserButton) click.
	(contextBuilder presenterAt: #queryDroplist)
		items: { query };
		selectItem: query.

	contextBuilder addNewComponent.

	self assert: browser specModel rootContext children size equals: 1.
	self
		assert: browser specModel rootContext children anyOne name
		equals: 'test'
]

{ #category : #tests }
MiCBConditionBuilderPresenterTest >> testFillWithQueryCondtion [

	| queriesBrowserRule |
	self setUpBuilderAsCreator.
	queriesBrowserRule := self conditionWithQuery.

	contextBuilder fillWithRuleComponent: queriesBrowserRule.
	self
		assert: self builderTitleField text
		equals: queriesBrowserRule name.
	self
		assert: self builderCodeInputField text
		equals: '[ :entity | entity ]'.
	self
		assert: self builderSummaryField text
		equals: queriesBrowserRule summary
]

{ #category : #accessing }
MiCBConditionBuilderPresenterTest >> toolClass [

	^ MiCBConditionBuilderPresenter
]
