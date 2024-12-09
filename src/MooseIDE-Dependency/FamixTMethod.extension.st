Extension { #name : #FamixTMethod }

{ #category : #'*MooseIDE-Dependency' }
FamixTMethod >> addNonAssociationDependenciesTo: dependencies [
	"Same method as in FamixTTypedEntity + one statement at the begining.
	 With inheritance we would have liked to do this `statement + super addNonAssociationDependenciesTo: dependencies`
	 but this is not possible with traits, so we copy the code"

	self children do: [ :c | c addNonAssociationDependenciesTo: dependencies ].

	declaredType ifNotNil: [

		( (declaredType usesFamixTrait: FamixTParametricEntity) and:
		[ declaredType genericization isNotNil ])
			ifTrue: [
				dependencies add: declaredType genericization.

				declaredType concreteParameters do: [ :param |
					param children ifNotEmpty: [ dependencies add: param ]
				]
			]
			ifFalse: [ dependencies add: declaredType ]
	]
]
