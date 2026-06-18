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
MiDeadJavaNonDefaultConstructorRule >> hasNotDeadconstructor: aTWithMethod [

	| deadMethods |
	deadMethods := deadCodeModel deadEntities.

	^aTWithMethod methods anySatisfy: [ :m |
		m isConstructor and: [ (deadMethods includes: m) not ]
	]
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

	^(self hasNotDeadconstructor: parentType) not
]
