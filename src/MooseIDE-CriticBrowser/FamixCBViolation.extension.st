Extension { #name : 'FamixCBViolation' }

{ #category : '*MooseIDE-CriticBrowser' }
FamixCBViolation >> mooseIcon [

	^ self iconNamed: self violatedCondition severity iconName
]

{ #category : '*MooseIDE-CriticBrowser' }
FamixCBViolation >> severityLevel [

	^ self violatedCondition severity level
]
