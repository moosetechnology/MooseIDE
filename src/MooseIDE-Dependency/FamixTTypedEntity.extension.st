Extension { #name : #FamixTTypedEntity }

{ #category : #'*MooseIDE-Dependency' }
FamixTTypedEntity >> addDeclaredTypesIn: dependencies [

	self declaredType ifNotNil: [
		dependencies add: self declaredType.
		"if decalredType is a ParametricClass, then need to go to its genericization"
	]
]
