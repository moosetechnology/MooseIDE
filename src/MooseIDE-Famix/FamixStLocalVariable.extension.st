Extension { #name : 'FamixStLocalVariable' }

{ #category : '*MooseIDE-Famix' }
FamixStLocalVariable >> accept: aVisitor [

	^aVisitor visitFamixStLocalVariable: self
]
