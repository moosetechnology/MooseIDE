Extension { #name : #FamixTMethod }

{ #category : #'*MooseIDE-Dependency' }
FamixTMethod >> addNonAssociationDependenciesTo: dependencies [

	self children do: [ :c | c addNonAssociationDependenciesTo: dependencies ].
	self declaredType ifNotNil: [ dependencies add: self declaredType ]
]
