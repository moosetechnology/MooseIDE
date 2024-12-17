Extension { #name : #FamixTClass }

{ #category : #'*MooseIDE-Dependency' }
FamixTClass >> queryAllOutgoingForDSM [

	| dependencies |

	dependencies := self queryAllOutgoing.
	self children do: [ :c | dependencies addAll: c queryAllOutgoingForDSM ].

	^dependencies

]
