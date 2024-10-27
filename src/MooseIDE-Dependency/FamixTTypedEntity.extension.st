Extension { #name : #FamixTTypedEntity }

{ #category : #'*MooseIDE-Dependency' }
FamixTTypedEntity >> addDeclaredTypesIn: dependencies [

	self declaredType ifNotNil: [dependencies add: self declaredType]
]
