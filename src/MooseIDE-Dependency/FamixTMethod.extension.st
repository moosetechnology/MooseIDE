Extension { #name : #FamixTMethod }

{ #category : #'*MooseIDE-Dependency' }
FamixTMethod >> addNonAssociationDependenciesTo: dependencies [

	self children do: [ :c | c addNonAssociationDependenciesTo: dependencies ].

	declaredType ifNotNil: [
		dependencies add: declaredType.

		( (declaredType usesFamixTrait: FamixTParametricEntity) and:
		[ declaredType genericization isNotNil ])
			ifTrue: [
				declaredType concreteParameters do: [ :param |
					param children ifNotEmpty: [ dependencies add: param ]
				]
			]

	]
]
