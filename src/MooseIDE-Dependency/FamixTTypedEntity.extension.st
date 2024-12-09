Extension { #name : #FamixTTypedEntity }

{ #category : #'*MooseIDE-Dependency' }
FamixTTypedEntity >> addNonAssociationDependenciesTo: dependencies [
	"if declaredType is a Concretization of a ParametricEntity, then must look at its concreteParameters
	 if they are actual classes (not GenericParameterType), then add them as dependencies
	 This is check through an heuristic: if they have some children, then it must be an actual class"

	declaredType ifNotNil: [

		( (declaredType usesFamixTrait: FamixTParametricEntity) and:
		[ declaredType genericization isNotNil ])
			ifTrue: [
				dependencies add: declaredType genericization.

				declaredType concreteParameters do: [ :param |
					param children ifNotEmpty: [ dependencies add: param ]
				]
			]

	]
]
