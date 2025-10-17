"
A MiCriticBrowserContextMakerPresenterTest is a test class for testing the behavior of MiCriticBrowserContextMakerPresenter
"
Class {
	#name : 'MiCBContextBuilderPresenterTest',
	#superclass : 'MiCBRuleComponentBuilderPresenterTest',
	#category : 'MooseIDE-CriticBrowser-Tests',
	#package : 'MooseIDE-CriticBrowser-Tests'
}

{ #category : 'running' }
MiCBContextBuilderPresenterTest >> otherComponent [

	^ FamixCBContext
		  named: 'Test-edited'
		  on: '[ :col | col allClasses ]'
		  summary: 'Context modified by tests'
]

{ #category : 'running' }
MiCBContextBuilderPresenterTest >> ruleComponentToEdit [

	^ FamixCBContext
		  named: 'Test'
		  on: '[ :col | col ]'
		  summary: 'Context used in tests'
]

{ #category : 'accessing' }
MiCBContextBuilderPresenterTest >> toolClass [

	^ MiCBContextBuilderPresenter
]
