Extension { #name : 'FamixTPackage' }

{ #category : '*MooseIDE-DSM' }
FamixTPackage >> queryAllOutgoingForDSM [
	"DO NOT USE OUTSIDE THE CONTEXT OF DSM.
See declaration in TEntityMetalevelDependency for context."

	| dependencies |
	dependencies := Set new.
	self containedEntities do: [ :c |
		dependencies addAll: c queryAllOutgoingForDSM ].

	^ dependencies
]
