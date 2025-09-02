Extension { #name : #FamixTPackage }

{ #category : #'*MooseIDE-Dependency' }
FamixTPackage >> queryAllOutgoingForDSM [
	"DO NOT USE OUTSIDE THE CONTEXT OF DSM.
See declaration in TEntityMetalevelDependency for context."

	| dependencies |
	dependencies := Set new.
	self children do: [ :c |
		dependencies addAll: c queryAllOutgoingForDSM ].

	^ dependencies
]
