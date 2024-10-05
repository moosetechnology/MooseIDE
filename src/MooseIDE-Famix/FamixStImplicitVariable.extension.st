Extension { #name : #FamixStImplicitVariable }

{ #category : #'*MooseIDE-Famix' }
FamixStImplicitVariable >> accept: aVisitor [

	^aVisitor visitFamixStImplicitVariable: self
]
