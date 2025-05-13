Extension { #name : #FamixTMethod }

{ #category : #'*MooseIDE-Dependency' }
FamixTMethod >> queryAllOutgoingForDSM [

	| dependencies |
	dependencies := self queryAllOutgoing asSet.

	self children do: [ :c |
		dependencies addAll: c queryAllOutgoingForDSM ].

	self declaredType ifNotNil: [ :declaredType |
		declaredType isParametricEntity ifTrue: [
			dependencies addAll: self typing concretizations ] ].

	^ dependencies
]
