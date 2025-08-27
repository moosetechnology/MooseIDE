Extension { #name : 'TEntityMetaLevelDependency' }

{ #category : '*MooseIDE-Dependency' }
TEntityMetaLevelDependency >> queryAllOutgoingForDSM [
	"DO NOT USE OUTSIDE THE CONTEXT OF DSM"

	"This is a hook for a temporary custom implementation to ensure we get all relevant dependencies in DSM.
It has been used before EntityTyping to get the declared type of typed entities.
It is now relevant only in the context of parametric associations, to get to the type argument.
When this dependency is resolved, this hook will be obsolete.
"

	^ self query outgoing dependencies asSet
]
