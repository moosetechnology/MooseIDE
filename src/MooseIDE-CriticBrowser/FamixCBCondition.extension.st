Extension { #name : #FamixCBCondition }

{ #category : #'*MooseIDE-CriticBrowser' }
FamixCBCondition >> editorClass [

	^ MiCBConditionBuilderPresenter
]

{ #category : #'*MooseIDE-CriticBrowser' }
FamixCBCondition >> newMemento [

	^ MiConditionMemento on: self
]

{ #category : #'*MooseIDE-CriticBrowser' }
FamixCBCondition >> reset [

	self removeAllViolations
]
