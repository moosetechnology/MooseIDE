Extension { #name : #FamixStAttribute }

{ #category : #'*MooseIDE-Famix' }
FamixStAttribute >> accept: aVisitor [

	^aVisitor visitFamixStAttribute: self
]
