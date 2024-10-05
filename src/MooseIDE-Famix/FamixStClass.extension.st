Extension { #name : #FamixStClass }

{ #category : #'*MooseIDE-Famix' }
FamixStClass >> accept: aVisitor [

	^aVisitor visitFamixStClass: self
]

{ #category : #'*MooseIDE-Famix' }
FamixStClass >> textIntervalForChild: aChildEntity [
	"looks for the definition of #aChildEntity within the generated #sourceText of the receiver"

	| stMethodName startPos |

	stMethodName := self name , ' >> ' , aChildEntity name.
	startPos := self sourceText indexOfSubCollection: stMethodName .
	^(startPos = 0)
		ifTrue: [ nil ]
		ifFalse: [ Interval from: startPos to: (startPos + aChildEntity sourceText size)]
]
