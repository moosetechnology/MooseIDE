Extension { #name : #FamixCBTRuleComponent }

{ #category : #'*MooseIDE-CriticBrowser' }
FamixCBTRuleComponent >> editionPresenter [

	^ self editorClass on: self newMemento
]

{ #category : #'*MooseIDE-CriticBrowser' }
FamixCBTRuleComponent >> editorClass [

	self shouldBeImplemented
]

{ #category : #'*MooseIDE-CriticBrowser' }
FamixCBTRuleComponent >> newMemento [

	self shouldBeImplemented
]
