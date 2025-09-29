Extension { #name : #HNode }

{ #category : #'*MooseIDE-Dependency' }
HNode >> hasTagAncestor [

	"Return tue if this node is in a tag node"

	"If parent is nil, we did not find a tag in the hierarchy."

	parent ifNil: [ ^ false ].
	"If parent rawModel is a tag, don't need to continue."
	^ parent rawModel isTag or: [ parent hasTagAncestor ]
]
