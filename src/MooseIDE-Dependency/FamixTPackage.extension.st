Extension { #name : #FamixTPackage }

{ #category : #'*MooseIDE-Dependency' }
FamixTPackage >> addNonAssociationDependenciesTo: dependencies [

	self children do: [ :c | c addNonAssociationDependenciesTo: dependencies ].
]
