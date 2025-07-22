Extension { #name : 'FamixStImplicitVariable' }

{ #category : '*MooseIDE-Famix' }
FamixStImplicitVariable >> accept: aVisitor [

	^aVisitor visitFamixStImplicitVariable: self
]

{ #category : '*MooseIDE-Famix' }
FamixStImplicitVariable >> sourceCodeBoundingEntity [

	^nil
]
