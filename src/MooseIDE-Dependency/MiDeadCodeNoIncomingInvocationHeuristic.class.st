"
Most basic heuristic for dead code: any behavioural entiy not invoked is dead
"
Class {
	#name : #MiDeadCodeNoIncomingInvocationHeuristic,
	#superclass : #MiDeadCodeAbstractHeuristic,
	#category : #'MooseIDE-Dependency-DeadCode'
}

{ #category : #accessing }
MiDeadCodeNoIncomingInvocationHeuristic >> description [

	^'Methods never invoked are considered dead'
]

{ #category : #testing }
MiDeadCodeNoIncomingInvocationHeuristic >> isDead: aTMethod [

	^aTMethod incomingInvocations isEmpty
]

{ #category : #accessing }
MiDeadCodeNoIncomingInvocationHeuristic >> name [

	^'Not invoked method'
]
