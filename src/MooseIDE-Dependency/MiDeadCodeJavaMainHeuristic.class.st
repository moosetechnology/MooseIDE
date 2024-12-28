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

{ #category : #testing }
MiDeadCodeJavaMainHeuristic >> isDead: aTMethod [

	(aTMethod name = 'main') ifFalse: [ ^true ].
	aTMethod declaredType ifNil: [ ^true ].
	(aTMethod declaredType name = 'void') ifNil: [ ^true ].
	aTMethod isClassSide ifFalse: [ ^true ].

	^false
]

{ #category : #accessing }
MiDeadCodeJavaMainHeuristic >> name [

	^super name , 'main()'
]
