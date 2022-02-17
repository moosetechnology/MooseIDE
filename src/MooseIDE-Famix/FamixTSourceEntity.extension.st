Extension { #name : #FamixTSourceEntity }

{ #category : #'*MooseIDE-Famix' }
FamixTSourceEntity >> childInterval: aChildEntity [
	"receiver is the parent of aChildEntity,
	returns the child code interval within the receiver's source text"

	^self sourceAnchor
		ifNotNil: [ :anchor | anchor childInterval: aChildEntity ]
]
