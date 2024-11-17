Extension { #name : #FamixTClass }

{ #category : #'*MooseIDE-Dependency' }
FamixTClass >> addNonAssociationDependenciesTo: dependencies [

	self children do: [ :c | c addNonAssociationDependenciesTo: dependencies ].
	
]
