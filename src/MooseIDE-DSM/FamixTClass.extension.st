Extension { #name : 'FamixTClass' }

{ #category : '*MooseIDE-DSM' }
FamixTClass >> queryAllOutgoingForDSM [
	"DO NOT USE OUTSIDE THE CONTEXT OF DSM.
See declaration in TEntityMetalevelDependency for context."

	| dependencies |
	dependencies := (self queryOutgoing: FamixTInheritance) asSet.
	self containedEntities do: [ :c | dependencies addAll: c queryAllOutgoingForDSM ].

	^ dependencies
]
