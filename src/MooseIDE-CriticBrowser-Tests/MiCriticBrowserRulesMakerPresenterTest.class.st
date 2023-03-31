"
A MiCriticBrowserQueryMakerPresenterTest is a test class for testing the behavior of MiCriticBrowserQueryMakerPresenter
"
Class {
	#name : #MiCriticBrowserRulesMakerPresenterTest,
	#superclass : #MiAbstractBrowserTest,
	#instVars : [
		'addQueryPresenter',
		'editQueryPresenter'
	],
	#category : #'MooseIDE-CriticBrowser-Tests'
}

{ #category : #running }
MiCriticBrowserRulesMakerPresenterTest >> browserClass [
	^ MiCriticBrowser 
]

{ #category : #running }
MiCriticBrowserRulesMakerPresenterTest >> setUp [
	super setUp.
	browser addRulesPresenter setParentContext: browser model rootContext.
	addQueryPresenter := browser addRulesPresenter queryPresenter.
	editQueryPresenter := browser rulesEditorPresenter queryPresenter.
	browser addRulesPresenter openDialog
	

]

{ #category : #running }
MiCriticBrowserRulesMakerPresenterTest >> tearDown [
	super tearDown.
	browser addRulesPresenter window close
]

{ #category : #test }
MiCriticBrowserRulesMakerPresenterTest >> testAddInputtedCodeRule [
	addQueryPresenter codeButtonAction.
	addQueryPresenter ruleTitle text: 'test'.
	addQueryPresenter codeInput text: '[ :entity | entity isDead ]'.
	addQueryPresenter addButtonAction.
	
	self assert: browser model rootContext children size equals: 1.
	self assert: browser model rootContext children anyOne name equals: 'test'
]

{ #category : #test }
MiCriticBrowserRulesMakerPresenterTest >> testAddInputtedFQRule [
	| query |
	query := FQBooleanQuery property: #isStub.
	addQueryPresenter queriesBrowserButton click.
	addQueryPresenter ruleTitle text: 'test'.
	addQueryPresenter queryDroplist items: { query }.
	addQueryPresenter queryDroplist selectItem: query.
	addQueryPresenter addButtonAction.
	
	self assert: browser model rootContext children size equals: 1.
	self assert: browser model rootContext children anyOne name equals: 'test'.
]

{ #category : #test }
MiCriticBrowserRulesMakerPresenterTest >> testCodeButtonAction [
	addQueryPresenter codeButtonAction.
	self assert: addQueryPresenter codeInput isVisible equals: true.
	self assert: addQueryPresenter queryDroplist isVisible equals: false
]

{ #category : #test }
MiCriticBrowserRulesMakerPresenterTest >> testEditRule [
	| rule newTitle newQuery newSummary |
	rule := FamixCBCondition named: 'test' on: (MiCriticBrowserPharoCodeQuery on: '[ :entity | entity isStub ]') summary: 'règle utilisée pour un test'.
	newTitle := 'test édité'.
	newQuery := '[ :entity | entity isDead ]'.
	newSummary := 'règle modifiée pour un test'.
	
	editQueryPresenter fillRuleToEdit: rule.
	editQueryPresenter ruleTitle text: newTitle.
	editQueryPresenter codeInput text: newQuery.
	editQueryPresenter ruleSummary text: newSummary.
	editQueryPresenter editRule: rule.
	self assert: rule name equals: newTitle.
	self assert: rule query query asString equals: newQuery.
	self assert: rule summary equals: newSummary
	
	
]

{ #category : #test }
MiCriticBrowserRulesMakerPresenterTest >> testFillRuleToEdit [
	| rule queriesBrowserRule |
	rule := FamixCBCondition named: 'test' on: (MiCriticBrowserPharoCodeQuery on: '[ :entity | entity isStub ]') summary: 'règle utilisée pour un test'.
	queriesBrowserRule := FamixCBCondition named: 'test2' on: (MiCriticBrowserFQQuery on: (FQBooleanQuery property: #isDead)) summary: 'autre règle utilisée pour un test'.
	
	addQueryPresenter codeButtonAction.
	addQueryPresenter fillRuleToEdit: rule.
	self assert: addQueryPresenter ruleTitle text equals: rule name.
	self assert: addQueryPresenter codeInput text equals: rule query query asString.
	self assert: addQueryPresenter ruleSummary text equals: rule summary.
	
	addQueryPresenter fillRuleToEdit: queriesBrowserRule.
	self assert: addQueryPresenter ruleTitle text equals: queriesBrowserRule name.
	self assert: addQueryPresenter codeInput text equals: '[ :entity | entity ]'.
	self assert: addQueryPresenter ruleSummary text equals: queriesBrowserRule summary
]

{ #category : #test }
MiCriticBrowserRulesMakerPresenterTest >> testQueriesBrowserButtonAction [
	addQueryPresenter queriesBrowserButtonAction.
	self assert: addQueryPresenter codeInput isVisible equals: false.
	self assert: addQueryPresenter queryDroplist isVisible equals: true
]

{ #category : #'tests - tags' }
MiCriticBrowserRulesMakerPresenterTest >> testSelectedTagSetAndGet [
	"already tested in MiCriticBrowserTest"
	self skip
]
