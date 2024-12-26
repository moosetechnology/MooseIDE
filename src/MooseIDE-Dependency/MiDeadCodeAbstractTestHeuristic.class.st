Class {
	#name : #MiDeadCodeAbstractTestHeuristic,
	#superclass : #MiDeadCodeAbstractHeuristic,
	#category : #'MooseIDE-Dependency-DeadCode'
}

{ #category : #accessing }
MiDeadCodeAbstractTestHeuristic >> description [ 

	^'Any method of a test class is considered not dead.
[Refute a method is dead]'
]

{ #category : #accessing }
MiDeadCodeAbstractTestHeuristic >> refuteDead [ 
	"any method in a test class is considered not dead"

	^true
]
