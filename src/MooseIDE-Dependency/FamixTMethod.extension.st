Extension { #name : #FamixTMethod }

{ #category : #'*MooseIDE-Dependency' }
FamixTMethod >> queryAllOutgoingForDSM [

	| dependencies |

	dependencies := self queryAllOutgoing asSet.
	(self children do: [ :c | dependencies addAll: c queryAllOutgoingForDSM ]).
	
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
