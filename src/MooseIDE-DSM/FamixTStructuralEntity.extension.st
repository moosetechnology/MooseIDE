Extension { #name : 'FamixTStructuralEntity' }

{ #category : '*MooseIDE-DSM' }
FamixTStructuralEntity >> queryAllOutgoingForDSM [
	"DO NOT USE OUTSIDE THE CONTEXT OF DSM.
See declaration in TEntityMetalevelDependency for context."

	| dependencies |
	dependencies := Set new: 5.

	self typing isNotNil ifTrue: [
		dependencies add: self typing.
		self typing isParametricAssociation ifTrue: [
			dependencies addAll: self typing concretizations ] ].

	^ dependencies
]
