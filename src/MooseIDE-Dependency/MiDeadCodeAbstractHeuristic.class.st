Class {
	#name : #MiDeadCodeAbstractHeuristic,
	#superclass : #Object,
	#category : #'MooseIDE-Dependency-DeadCode'
}

{ #category : #testing }
MiDeadCodeAbstractHeuristic class >> isAbstract [

	^self name includesSubstring: 'Abstract'
]

{ #category : #accessing }
MiDeadCodeAbstractHeuristic >> description [

	self subclassResponsibility 
]

{ #category : #testing }
MiDeadCodeAbstractHeuristic >> isAbstract [

	^ self class isAbstract
]

{ #category : #testing }
MiDeadCodeAbstractHeuristic >> isDead: aTMethod [

	self subclassResponsibility 
]

{ #category : #accessing }
MiDeadCodeAbstractHeuristic >> name [

	self subclassResponsibility 
]

{ #category : #accessing }
MiDeadCodeAbstractHeuristic >> refuteDead [
	"if true, the heuristic tries to _refute_ a method is dead (or assert it is not dead)
	 if false, the heuristic tries to _assert_ a method is dead"

	^false
]
