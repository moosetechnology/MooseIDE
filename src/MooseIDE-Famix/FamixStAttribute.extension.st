Extension { #name : 'FamixStAttribute' }

{ #category : '*MooseIDE-Famix' }
FamixStAttribute >> accept: aVisitor [

	^aVisitor visitFamixStAttribute: self
]

{ #category : '*MooseIDE-Famix' }
FamixStAttribute >> displayedNameInMiSourceText [
	"To narrow down the search for an attribute, we look for this marker in the generated text for a class
	 because MiSourceTextStAnchorAdapter is only interested in the starting position of this
	 marker, it will work"

	^'#instVars : ['
]
