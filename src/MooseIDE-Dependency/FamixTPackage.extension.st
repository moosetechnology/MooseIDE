Extension { #name : #FamixTPackage }

{ #category : #'*MooseIDE-Dependency' }
FamixTPackage >> queryAllOutgoingForDSM [

	| dependencies |

	dependencies := self queryAllOutgoing.
	self children do: [ :c | dependencies addAll: c queryAllOutgoingForDSM ].

	^dependencies

]
