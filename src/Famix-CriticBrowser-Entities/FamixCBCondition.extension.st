Extension { #name : #FamixCBCondition }

{ #category : #'*Famix-CriticBrowser-Entities' }
FamixCBCondition >> removeAllViolations [
	[ violations isNotEmpty ] whileTrue: [ self removeViolation: violations anyOne ]
]

{ #category : #'*Famix-CriticBrowser-Entities' }
FamixCBCondition >> resetExecutionOfTree [ 
	self removeAllViolations
]
