"
A heuristic to recognize methods overriding another method that is called.

If a method in a super-class (or interface) is called, we assume any method implementing it in a concrete class can be called
"
Class {
	#name : 'MiDeadCodeJavaImplementsInterfaceHeuristic',
	#superclass : 'MiDeadCodeAbstractJavaHeuristic',
	#category : 'MooseIDE-DeadCode-Rules',
	#package : 'MooseIDE-DeadCode',
	#tag : 'Rules'
}

{ #category : 'testing' }
MiDeadCodeJavaImplementsInterfaceHeuristic >> any: tWithMethods declaresMethod: aTMethod [

	tWithMethods do: [ :aTWithMethods |
		aTWithMethods methods
			detect: [ :mth | mth signature = aTMethod signature ]
			ifOne: [ :mth | ^true ]
	].

	^false
]

{ #category : 'testing' }
MiDeadCodeJavaImplementsInterfaceHeuristic >> any: tWithMethods definesMethod: aTMethod [

	tWithMethods do: [ :aTWithMethods |
		aTWithMethods methods
			detect: [ :mth | (mth signature = aTMethod signature) and: [mth isAbstract not] ]
			ifOne: [ :mth | ^true ]
	].

	^false
]

{ #category : 'accessing' }
MiDeadCodeJavaImplementsInterfaceHeuristic >> description [

	^super description ,
	'A method implementing an interface method, even dead, is needed for the implementation'
]

{ #category : 'accessing' }
MiDeadCodeJavaImplementsInterfaceHeuristic >> name [

	^super name , 'Implements interface method'
]

{ #category : 'testing' }
MiDeadCodeJavaImplementsInterfaceHeuristic >> notDead: aTMethod [
	"if the method overrides a class method, this rule does not apply (return false))
	 otherwise if the method implements an interface method, then it is not dead"

	| superclasses implementedInterfaces |

	superclasses := aTMethod parentType superclassHierarchy
		reject: #isNil. "protect against a bug in VerveineJ"
	(self any: superclasses definesMethod: aTMethod)
		ifTrue: [ ^false ].

	implementedInterfaces := ({ aTMethod parentType } , superclasses)
		flatCollectAsSet: [ :c | self implementedInterfaceHierarchy: c ].
	(self any: implementedInterfaces declaresMethod: aTMethod)
		ifTrue: [ ^true ].

	^ false
]
