"
A heuristic to recognize methods overriding another method that is called.

If a method in a super-class (or interface) is called, we assume any method implementing it in a concrete class can be called
"
Class {
	#name : 'MiDeadCodeJavaOverridesInvokedHeuristic',
	#superclass : 'MiDeadCodeAbstractJavaHeuristic',
	#category : 'MooseIDE-DeadCode-Rules',
	#package : 'MooseIDE-DeadCode',
	#tag : 'Rules'
}

{ #category : 'testing' }
MiDeadCodeJavaOverridesInvokedHeuristic >> any: tWithMethods hasInvokedMethod: aTMethod [

	tWithMethods do: [ :aTWithMethods |
		aTWithMethods methods
			detect: [ :mth | (mth signature = aTMethod signature) and: [ mth incomingInvocations isNotEmpty ]]
			ifOne: [ :mth | ^true ]
	].

	^false
]

{ #category : 'accessing' }
MiDeadCodeJavaOverridesInvokedHeuristic >> description [

	^super description ,
	'All methods overriding an invoked method are assumed not-dead'
]

{ #category : 'accessing' }
MiDeadCodeJavaOverridesInvokedHeuristic >> name [

	^super name , 'Overriden invoked method'
]

{ #category : 'testing' }
MiDeadCodeJavaOverridesInvokedHeuristic >> notDead: aTMethod [


	| superclasses implementedInterfaces |

	superclasses := { aTMethod parentType } , (aTMethod parentType superclassHierarchy).
	(self any: superclasses hasInvokedMethod: aTMethod)
		ifTrue: [ ^true ].

	implementedInterfaces := superclasses flatCollectAsSet: [ :c | self implementedInterfaceHierarchy: c ].
	(self any: implementedInterfaces hasInvokedMethod: aTMethod)
		ifTrue: [ ^true ].

	^ false
]
