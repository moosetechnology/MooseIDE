Class {
	#name : #MiDeadCodeNoIncomingInvocationHeuristic,
	#superclass : #MiDeadCodeAbstractHeuristic,
	#category : #'MooseIDE-Dependency-DeadCode'
}

{ #category : #testing }
MiDeadCodeNoIncomingInvocationHeuristic >> isDead: aTMethod [

	^aTMethod incomingInvocations isEmpty
]
