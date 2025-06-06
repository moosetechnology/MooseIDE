"
A heuristic to recognize 'public static void main()' function in Java
"
Class {
	#name : #MiDeadCodeJavaMainHeuristic,
	#superclass : #MiDeadCodeAbstractJavaHeuristic,
	#category : #'MooseIDE-Dependency-DeadCode'
}

{ #category : #accessing }
MiDeadCodeJavaMainHeuristic >> description [

	^super description ,
	'Java "public static void main()" methods are not dead'
]

{ #category : #accessing }
MiDeadCodeJavaMainHeuristic >> name [

	^super name , 'main()'
]

{ #category : #testing }
MiDeadCodeJavaMainHeuristic >> notDead: aTMethod [

	(aTMethod name = 'main') ifFalse: [ ^false ].
	aTMethod declaredType ifNil: [ ^false ].
	(aTMethod declaredType name = 'void') ifNil: [ ^false ].
	aTMethod isClassSide ifFalse: [ ^false ].

	^true
]
