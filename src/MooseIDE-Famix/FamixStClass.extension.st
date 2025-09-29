Extension { #name : #FamixStClass }

{ #category : #'*MooseIDE-Famix' }
FamixStClass >> accept: aVisitor [

	^aVisitor visitFamixStClass: self
]
