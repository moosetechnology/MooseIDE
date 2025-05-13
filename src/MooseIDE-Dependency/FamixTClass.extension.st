Extension { #name : #FamixTClass }

{ #category : #'*MooseIDE-Dependency' }
FamixTClass >> queryAllOutgoingForDSM [

	| dependencies |
	dependencies := self queryOutgoingInheritances asSet.
	self children do: [ :c |
		dependencies addAll: c queryAllOutgoingForDSM ].

	^ dependencies
]
