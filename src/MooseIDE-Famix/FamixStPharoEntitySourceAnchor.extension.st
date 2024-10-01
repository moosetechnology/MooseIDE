Extension { #name : #FamixStPharoEntitySourceAnchor }

{ #category : #'*MooseIDE-Famix' }
FamixStPharoEntitySourceAnchor >> textIntervalForChild: aChildEntity [
	"For smalltalk entities, the sourceText is generated, so the sourceAnchor cannot do the job.
	 We leave it to the entities themselves to resolve this"

	^element textIntervalForChild: aChildEntity
]
