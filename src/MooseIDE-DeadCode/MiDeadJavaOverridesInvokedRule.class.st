"
A heuristic to recognize methods overriding another method that is called.

If a method in a super-class (or interface) is called, we assume any method implementing it in a concrete class can be called
"
Class {
	#name : 'MiDeadJavaOverridesInvokedRule',
	#superclass : 'MiDeadAbstractJavaRule',
	#category : 'MooseIDE-DeadCode-Rules',
	#package : 'MooseIDE-DeadCode',
	#tag : 'Rules'
}

{ #category : 'testing' }
MiDeadJavaOverridesInvokedRule >> any: tWithMethods hasInvokedMethod: aTMethod [

	tWithMethods do: [ :aTWithMethods |
		aTWithMethods methods
			detect: [ :mth | (mth signature = aTMethod signature) and: [ mth incomingInvocations isNotEmpty ]]
			ifOne: [ :mth | ^true ]
	].

	^false
]

{ #category : 'accessing' }
MiDeadJavaOverridesInvokedRule >> name [

	^super name , 'Overrides invoked method'
]

{ #category : 'testing' }
MiDeadJavaOverridesInvokedRule >> notDead: aTMethod [


	| superclasses implementedInterfaces |

	superclasses := { aTMethod parentType }.
	aTMethod parentType isClass
		ifTrue: [ superclasses := superclasses , (aTMethod parentType superclassHierarchy) ].

	(self any: superclasses hasInvokedMethod: aTMethod)
		ifTrue: [ ^true ].

	implementedInterfaces := superclasses flatCollectAsSet: [ :c | self implementedInterfaceHierarchy: c ].
	(self any: implementedInterfaces hasInvokedMethod: aTMethod)
		ifTrue: [ ^true ].

	^ false
]
