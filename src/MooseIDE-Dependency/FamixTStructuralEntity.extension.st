Extension { #name : #FamixTStructuralEntity }

{ #category : #'*MooseIDE-Dependency' }
FamixTStructuralEntity >> queryAllOutgoingForDSM [

	| dependencies |

	dependencies := Set new: 5.

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
	].

	^dependencies 
]
