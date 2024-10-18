Extension { #name : #FamixTMethod }

{ #category : #'*MooseIDE-Dependency' }
FamixTMethod >> addDeclaredTypesIn: dependencies [

	self children do: [ :c | c addDeclaredTypesIn: dependencies ].
	self declaredType ifNotNil: [ dependencies add: self declaredType ]
]
