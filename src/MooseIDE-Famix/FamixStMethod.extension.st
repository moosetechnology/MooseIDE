Extension { #name : #FamixStMethod }

{ #category : #'*MooseIDE-Famix' }
FamixStMethod >> accept: aVisitor [

	^aVisitor visitFamixStMethod: self
]

{ #category : #'*MooseIDE-Famix' }
FamixStMethod >> displayedNameInMiSourceText [

	self flag: 'Does not work for keyword methods because we are lacking the parameters names'.

	^String streamContents: [ :stream |
		stream << self parentType name.
		self isClassSide ifTrue: [ stream << ' class' ].
		stream
			<< ' >> ' ;
			<< self name
	]
]
