Extension { #name : #FamixTStructuralEntity }

{ #category : #'*MooseIDE-Dependency' }
FamixTStructuralEntity >> queryAllOutgoingForDSM [
	"DO NOT USE OUTSIDE THE CONTEXT OF DSM.
See declaration in TEntityMetalevelDependency for context."

	| dependencies |
	dependencies := Set new: 5.

	self typing isNotNil and: [
		self typing isParametricAssociation ifTrue: [
			dependencies addAll: self typing concretizations ] ].

	^ dependencies
]
