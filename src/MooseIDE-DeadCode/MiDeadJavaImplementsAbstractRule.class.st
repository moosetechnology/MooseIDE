"
A heuristic to recognize methods overriding another method that is called.

If a method in a super-class (or interface) is called, we assume any method implementing it in a concrete class can be called
"
Class {
	#name : 'MiDeadJavaImplementsAbstractRule',
	#superclass : 'MiDeadAbstractJavaRule',
	#category : 'MooseIDE-DeadCode-Rules',
	#package : 'MooseIDE-DeadCode',
	#tag : 'Rules'
}

{ #category : 'testing' }
MiDeadJavaImplementsAbstractRule >> any: tWithMethods declaresMethod: aTMethod [

	tWithMethods do: [ :aTWithMethods |
		aTWithMethods methods
			detect: [ :mth | mth signature = aTMethod signature ]
			ifOne: [ :mth | ^true ]
	].

	^false
]

{ #category : 'testing' }
MiDeadJavaImplementsAbstractRule >> collect: tWithMethods definedMethod: aTMethod [

	^tWithMethods
		collect: [ :aTWithMethods |
			aTWithMethods methods
				detect: [ :mth | mth signature = aTMethod signature ]
				ifNone: [ nil ]
		]
		thenReject: #isNil

]

{ #category : 'accessing' }
MiDeadJavaImplementsAbstractRule >> name [

	^super name , 'Implements abstract method'
]

{ #category : 'testing' }
MiDeadJavaImplementsAbstractRule >> notDead: aTMethod [
	"- Get all methods defined in super-classes
	   - if any one is not abstract, then return false, the rule does not apply
	   - if there is one, it must be abstract, return true (is not dead)
	 - Look at all methods defined in implemented interface
	   if any matches this method then return true (is not dead)"

	| superclasses definedMethods implementedInterfaces |

	superclasses := aTMethod parentType superclassHierarchy
		reject: #isNil. "protect against a bug in VerveineJ"

	definedMethods := self collect: superclasses definedMethod: aTMethod.
	
	definedMethods
		detect: [ :definedMethod | definedMethod isAbstract not ]
		ifOne: [ :definedMethod | ^false ].

	definedMethods ifNotEmpty: [ ^true ].

	implementedInterfaces := ({ aTMethod parentType } , superclasses)
		flatCollectAsSet: [ :c | self implementedInterfaceHierarchy: c ].

	(self any: implementedInterfaces declaresMethod: aTMethod)
		ifTrue: [ ^true ].

	^ false
]
