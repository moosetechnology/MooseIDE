"
Most basic heuristic for dead code: any behavioural entiy not invoked is dead
"
Class {
	#name : 'MiDeadNoIncomingInvocationRule',
	#superclass : 'MiDeadAbstractRule',
	#category : 'MooseIDE-DeadCode-Rules',
	#package : 'MooseIDE-DeadCode',
	#tag : 'Rules'
}

{ #category : 'accessing' }
MiDeadNoIncomingInvocationRule >> description [

	^super description ,
	'Methods never invoked are considered dead'
]

{ #category : 'testing' }
MiDeadNoIncomingInvocationRule >> isDead: aTMethod [

	^aTMethod incomingInvocations isEmpty
]

{ #category : 'accessing' }
MiDeadNoIncomingInvocationRule >> name [

	^super name , 'Not invoked method'
]

{ #category : 'testing' }
MiDeadNoIncomingInvocationRule >> notDead: aTMethod [

	^(self isDead: aTMethod) not
]

{ #category : 'accessing' }
MiDeadNoIncomingInvocationRule >> refuteDead [

	^false
]

{ #category : 'testing' }
MiDeadNoIncomingInvocationRule >> selectedByDefault [

	^true
]
