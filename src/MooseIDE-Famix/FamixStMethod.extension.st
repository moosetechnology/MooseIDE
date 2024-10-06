Extension { #name : #FamixStMethod }

{ #category : #'*MooseIDE-Famix' }
FamixStMethod >> accept: aVisitor [

	^aVisitor visitFamixStMethod: self
]

{ #category : #'*MooseIDE-Famix' }
FamixStMethod >> displayedNameInMiSourceText [

	^String streamContents: [ :stream |
		stream << self parentType name.
		self isClassSide ifTrue: [ stream << ' class' ].
		stream
			<< ' >> ' ;
			<< self name
	]
]
