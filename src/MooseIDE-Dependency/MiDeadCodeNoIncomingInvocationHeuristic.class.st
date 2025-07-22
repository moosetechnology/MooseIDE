"
Most basic heuristic for dead code: any behavioural entiy not invoked is dead
"
Class {
	#name : 'MiDeadCodeNoIncomingInvocationHeuristic',
	#superclass : 'MiDeadCodeAbstractHeuristic',
	#category : 'MooseIDE-Dependency-DeadCode',
	#package : 'MooseIDE-Dependency',
	#tag : 'DeadCode'
}

{ #category : 'accessing' }
MiDeadCodeNoIncomingInvocationHeuristic >> description [

	^super description ,
	'Methods never invoked are considered dead'
]

{ #category : 'testing' }
MiDeadCodeNoIncomingInvocationHeuristic >> isDead: aTMethod [

	^aTMethod incomingInvocations isEmpty
]

{ #category : 'accessing' }
MiDeadCodeNoIncomingInvocationHeuristic >> name [

	^super name , 'Not invoked method'
]

{ #category : 'testing' }
MiDeadCodeNoIncomingInvocationHeuristic >> notDead: aTMethod [

	^(self isDead: aTMethod) not
]

{ #category : 'accessing' }
MiDeadCodeNoIncomingInvocationHeuristic >> refuteDead [

	^false
]

{ #category : 'testing' }
MiDeadCodeNoIncomingInvocationHeuristic >> selectedByDefault [

	^true
]
