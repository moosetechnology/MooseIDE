"
In Java, if the superclass does not have a default constructor, the subclass must define an explicit constructor.
In such a case, a constructor that is not called must still be kept (not-dead) for the program to compile
"
Class {
	#name : 'MiDeadJavaNonDefaultConstructorRule',
	#superclass : 'MiDeadAbstractJavaRule',
	#instVars : [
		'deadCodeModel'
	],
	#category : 'MooseIDE-DeadCode-Rules',
	#package : 'MooseIDE-DeadCode',
	#tag : 'Rules'
}

{ #category : 'accessing' }
MiDeadJavaNonDefaultConstructorRule >> deadCodeModel: aBrowserModel [

	deadCodeModel := aBrowserModel
]

{ #category : 'testing' }
MiDeadJavaNonDefaultConstructorRule >> hasOtherConstructorNotDead: aTWithMethod [
	"Called to check whether a constructor can be considered dead or not.
	 If there is only one constructor, then there is no other
	 Other wise checks whether there is a constructor that is not dead"

	| deadMethods constructors |
	constructors := aTWithMethod methods select: [ :m | m isConstructor ].

	(constructors size < 2) ifTrue: [ ^false ].

	deadMethods := deadCodeModel deadEntities.
	^constructors anySatisfy: [ :c | (deadMethods includes: c) not ]
]

{ #category : 'accessing' }
MiDeadJavaNonDefaultConstructorRule >> name [

	^super name , 'Non default constructor without default one'
]

{ #category : 'testing' }
MiDeadJavaNonDefaultConstructorRule >> notDead: aTMethod [
	"if all constructors of the parentType are dead, then keep the constructors
	(ie. they are considered not dead)"

	| parentType |

	aTMethod isConstructor ifFalse: [ ^ false ].

	parentType := aTMethod parentType.
	(parentType superclass name = 'Object') ifTrue: [ ^ false ].

	^(self hasOtherConstructorNotDead: parentType) not
]
