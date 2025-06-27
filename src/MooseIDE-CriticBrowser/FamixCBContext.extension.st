Extension { #name : #FamixCBContext }

{ #category : #'*MooseIDE-CriticBrowser' }
FamixCBContext >> editorClass [

	^ MiCBContextBuilderPresenter
]

{ #category : #'*MooseIDE-CriticBrowser' }
FamixCBContext >> reset [

	self resetExecutionOfTree
]
