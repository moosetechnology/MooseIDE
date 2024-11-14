Extension { #name : #FamixTParametricEntity }

{ #category : #'*MooseIDE-Dependency' }
FamixTParametricEntity >> addDeclaredTypesIn: dependencies [

	self children do: [ :c | c addDeclaredTypesIn: dependencies ]
]
