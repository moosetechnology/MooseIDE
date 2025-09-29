Extension { #name : #FamixTComment }

{ #category : #'*MooseIDE-Famix' }
FamixTComment >> sourceCodeBoundingEntity [
	"this is for SourceAnchorAdapter to find the dipslayed entity containing this comment"

	^self commentedEntity
]

{ #category : #'*MooseIDE-Famix' }
FamixTComment >> stringToHighlight [
	"this is for SourceAnchorAdapter"

	^ self sourceText
]
