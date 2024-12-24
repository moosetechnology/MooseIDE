Class {
	#name : #MiDeadCodeAbstractHeuristic,
	#superclass : #Object,
	#category : #'MooseIDE-Dependency-DeadCode'
}

{ #category : #testing }
MiDeadCodeAbstractHeuristic >> description [

	self subclassResponsibility 
]

{ #category : #testing }
MiDeadCodeAbstractHeuristic >> isDead: aTMethod [

	self subclassResponsibility 
]

{ #category : #testing }
MiDeadCodeAbstractHeuristic >> name [

	self subclassResponsibility 
]

{ #category : #testing }
MiDeadCodeAbstractHeuristic >> refuteDead [
	"if true, the heuristic tries to _refute_ a method is dead
	 if false, the heuristic tries to _assert_ a method is dead"

	^false
]
