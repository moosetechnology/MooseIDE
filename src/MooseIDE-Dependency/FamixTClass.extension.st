Extension { #name : #FamixTClass }

{ #category : #'*MooseIDE-Dependency' }
FamixTClass >> addDeclaredTypesIn: dependencies [

	self children do: [ :c | c addDeclaredTypesIn: dependencies ].
	
]
