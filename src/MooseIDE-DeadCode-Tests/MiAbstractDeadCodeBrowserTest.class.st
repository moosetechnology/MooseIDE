Class {
	#name : 'MiAbstractDeadCodeBrowserTest',
	#superclass : 'MiAbstractBrowserTest',
	#category : 'MooseIDE-DeadCode-Tests',
	#package : 'MooseIDE-DeadCode-Tests'
}

{ #category : 'accessing - attributes' }
MiAbstractDeadCodeBrowserTest >> browserCandidateEntitiesLabelPresenter [

	^browser presenterAt: #lblAllMethods
]

{ #category : 'accessing - attributes' }
MiAbstractDeadCodeBrowserTest >> browserCandidateEntitiesListPresenter [

	^browser presenterAt: #lstMethod
]

{ #category : 'accessing - attributes' }
MiAbstractDeadCodeBrowserTest >> browserChooseRulesButtonPresenter [

	^(browser presenterAt: #ruleColumn)
		presenterAt: #btnChooseRules
]

{ #category : 'accessing - attributes' }
MiAbstractDeadCodeBrowserTest >> browserChosenRulesTreePresenter [

	^(browser presenterAt: #ruleColumn)
		presenterAt: #lstChosenRules
]

{ #category : 'running' }
MiAbstractDeadCodeBrowserTest >> browserClass [

	^MiDeadBrowser
]

{ #category : 'accessing - attributes' }
MiAbstractDeadCodeBrowserTest >> browserClearDeadButtonPresenter [

	^(browser presenterAt: #resultColumn)
		presenterAt: #btnClear
]

{ #category : 'accessing - attributes' }
MiAbstractDeadCodeBrowserTest >> browserDeadEntitiesLabelPresenter [

	^(browser presenterAt: #resultColumn)
		presenterAt: #lblDeadMethods
]

{ #category : 'accessing - attributes' }
MiAbstractDeadCodeBrowserTest >> browserDeadEntitiesListPresenter [

	^(browser presenterAt: #resultColumn)
		presenterAt: #lstDeadMethods
]

{ #category : 'accessing - attributes' }
MiAbstractDeadCodeBrowserTest >> browserOfferedRuleTreePresenter [

	^(browser presenterAt: #ruleColumn)
		presenterAt: #lstOfferedRules
]

{ #category : 'accessing - attributes' }
MiAbstractDeadCodeBrowserTest >> browserRunButtonPresenter [

	^(browser presenterAt: #resultColumn)
		presenterAt: #btnRun
]

{ #category : 'accessing - attributes' }
MiAbstractDeadCodeBrowserTest >> browserUnChooseRulesButtonPresenter [

	^(browser presenterAt: #ruleColumn)
		presenterAt: #btnRejectRules
]

{ #category : 'running' }
MiAbstractDeadCodeBrowserTest >> populateBrowser: mooseModel [

	mooseModel newMethodNamed: 'aMethod'.
	mooseModel newMethodNamed: 'anotherMethod'.
	mooseModel newInvocation
		sender: (mooseModel entityNamed: 'aMethod') ;
		candidates: { mooseModel entityNamed: 'anotherMethod' }.

	browser followEntity: mooseModel allMethods.

]

{ #category : 'running' }
MiAbstractDeadCodeBrowserTest >> selectOfferedRule: aRuleClass [

	| itemToSelect |
	itemToSelect := self browserOfferedRuleTreePresenter roots
		detect: [ :item | item class = aRuleClass ].

	self browserOfferedRuleTreePresenter selectItem: itemToSelect.

	^itemToSelect 
]
