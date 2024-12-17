Extension { #name : #FamixTTypedEntity }

{ #category : #'*MooseIDE-Dependency' }
FamixTTypedEntity >> queryAllOutgoingForDSM [

	| dependencies |

	dependencies := self queryAllOutgoing.

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
