Extension { #name : #FamixTStructuralEntity }

{ #category : #'*MooseIDE-Dependency' }
FamixTStructuralEntity >> queryAllOutgoingForDSM [
	"DO NOT USE OUTSIDE THE CONTEXT OF DSM.
See declaration in TEntityMetalevelDependency for context."

	| dependencies |
	dependencies := Set new: 5.

	self declaredType ifNotNil: [ :declaredType |
		declaredType isParametricEntity ifTrue: [
			dependencies addAll: self typing concretizations ] ].

	^ dependencies
]
