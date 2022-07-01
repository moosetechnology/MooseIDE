Extension { #name : #FamixCBCondition }

{ #category : #'*Famix-CriticBrowser-Entities' }
FamixCBCondition >> removeAllViolations [
	[ violations isNotEmpty ] whileTrue: [ self removeViolation: violations anyOne ]
]

{ #category : #'*Famix-CriticBrowser-Entities' }
FamixCBCondition >> removeAllViolationsFromTree [ 
	self removeAllViolations
]

{ #category : #'*Famix-CriticBrowser-Entities' }
FamixCBCondition >> removeViolation: aViolation [
	self violations remove: aViolation ifAbsent: [ ^ self ].
	aViolation violatingEntity ifNotNil: [ aViolation violatingEntity removeViolation: aViolation ]
]
