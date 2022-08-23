Extension { #name : #FamixTSourceEntity }

{ #category : #'*MooseIDE-Famix' }
FamixTSourceEntity >> textIntervalForChild: aChildEntity [
	"receiver is the parent of aChildEntity,
	returns the child code interval within the receiver's source text"

	^self sourceAnchor
		ifNotNil: [ :anchor | anchor textIntervalForChild: aChildEntity ]
]
