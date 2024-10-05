Extension { #name : #FamixStMethod }

{ #category : #'*MooseIDE-Famix' }
FamixStMethod >> accept: aVisitor [

	^aVisitor visitFamixStMethod: self
]

{ #category : #'*MooseIDE-Famix' }
FamixStMethod >> displayedNameInMiSourceText [

	^String streamContents: [ :stream |
		stream << self parentType name.
		self isClassSide ifTrue: [ stream << ' class' ].
		stream
			<< ' >> ' ;
			<< self name
	]
]

{ #category : #'*MooseIDE-Famix' }
FamixStMethod >> textIntervalForChild: aChildEntity [
	"looks for the definition of #aChildEntity within the generated #sourceText of the receiver
	 First looks for the text of the receiver in its parent text"

	| myInterval |
1halt.
	myInterval := self parentType textIntervalForChild: self.
	^nil
]
