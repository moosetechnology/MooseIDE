Extension { #name : 'FamixTClass' }

{ #category : '*MooseIDE-Dependency' }
FamixTClass >> queryAllOutgoingForDSM [
	"DO NOT USE OUTSIDE THE CONTEXT OF DSM.
See declaration in TEntityMetalevelDependency for context."

	| dependencies |
	dependencies := self queryOutgoingInheritances asSet.
	self children do: [ :c |
		dependencies addAll: c queryAllOutgoingForDSM ].

	^ dependencies
]
