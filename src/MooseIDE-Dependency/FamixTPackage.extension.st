Extension { #name : #FamixTPackage }

{ #category : #'*MooseIDE-Dependency' }
FamixTPackage >> queryAllOutgoingForDSM [

	| dependencies |
	dependencies := Set new.
	self children do: [ :c |
		dependencies addAll: c queryAllOutgoingForDSM ].

	^ dependencies
]
