Extension { #name : 'FamixTMethod' }

{ #category : '*MooseIDE-Dependency' }
FamixTMethod >> queryAllOutgoingForDSM [
	"DO NOT USE OUTSIDE THE CONTEXT OF DSM.
See declaration in TEntityMetalevelDependency for context."

	| dependencies |
	dependencies := self queryAllOutgoing asSet.

	self children do: [ :c |
		dependencies addAll: c queryAllOutgoingForDSM ].

	self typing isNotNil and: [
		self typing isParametricAssociation ifTrue: [
			dependencies addAll: self typing concretizations ] ].

	^ dependencies
]
