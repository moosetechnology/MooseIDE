"
A MiCriticBrowserEditRulePresenterTest is a test class for testing the behavior of MiCriticBrowserEditRulePresenter
"
Class {
	#name : #MiCriticBrowserEditRulePresenterTest,
	#superclass : #MiAbstractBrowserTest,
	#instVars : [
		'rulesEditor'
	],
	#category : #'MooseIDE-CriticBrowser-Tests'
}

{ #category : #running }
MiCriticBrowserEditRulePresenterTest >> browserClass [ 
	^ MiCriticBrowser 
]

{ #category : #initialization }
MiCriticBrowserEditRulePresenterTest >> setUp [
	super setUp.
	rulesEditor := browser rulesEditorPresenter.
]

{ #category : #test }
MiCriticBrowserEditRulePresenterTest >> testHasBeenEdited [
	| rule stubEntity |
	rule := FamixCBRule named: 'test' on: ((MiCriticBrowserPharoCodeQuery on: '[ :entity | entity isStub ]')).
	stubEntity := FamixStMethod new.
	stubEntity name: 'test1'; isStub: true.
	
	browser model addRule: rule.
	browser model setEntities: { stubEntity } asMooseGroup.
	browser model runRules.
	self assert: (browser model violations includesKey: rule) equals: true.
	browser updateRulesList.
	self assert: browser rules roots anyOne name equals: 'test'.
	
	rule name: 'test édité'.
	rulesEditor hasBeenEdited: rule.
	self assert: (browser model violations includesKey: rule) equals: false.
	self assert: browser rules roots anyOne name equals: 'test édité'
]
