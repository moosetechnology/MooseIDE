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
	rulesEditor := browser rulesEditorPresenter
]
