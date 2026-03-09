"
A heuristic to recognize 'public static void main()' function in Java
"
Class {
	#name : 'MiDeadJavaMainRule',
	#superclass : 'MiDeadAbstractJavaRule',
	#category : 'MooseIDE-DeadCode-Rules',
	#package : 'MooseIDE-DeadCode',
	#tag : 'Rules'
}

{ #category : 'testing' }
MiDeadJavaMainRule >> accept: aTMethod [

	^self notDead: aTMethod 
]

{ #category : 'accessing' }
MiDeadJavaMainRule >> description [

	^super description ,
	'"public static void main()" methods are assumed not-dead'
]

{ #category : 'accessing' }
MiDeadJavaMainRule >> isForEntryPoint [

	^true
]

{ #category : 'accessing' }
MiDeadJavaMainRule >> name [

	^super name , 'main()'
]

{ #category : 'testing' }
MiDeadJavaMainRule >> notDead: aTMethod [

	(aTMethod name = 'main') ifFalse: [ ^false ].
	aTMethod declaredType ifNil: [ ^false ].
	(aTMethod declaredType name = 'void') ifNil: [ ^false ].
	aTMethod isClassSide ifFalse: [ ^false ].

	^true
]
