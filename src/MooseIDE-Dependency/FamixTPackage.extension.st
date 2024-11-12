Extension { #name : #FamixTPackage }

{ #category : #'*MooseIDE-Dependency' }
FamixTPackage >> addDeclaredTypesIn: dependencies [

	self children do: [ :c | c addDeclaredTypesIn: dependencies ].
]
