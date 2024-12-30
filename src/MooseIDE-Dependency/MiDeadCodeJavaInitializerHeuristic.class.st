Class {
	#name : #MiDeadCodeJavaInitializerHeuristic,
	#superclass : #MiDeadCodeAbstractJavaHeuristic,
	#category : #'MooseIDE-Dependency-DeadCode'
}

{ #category : #accessing }
MiDeadCodeJavaInitializerHeuristic >> description [

	^super description ,
	'Initialization block in Java are assumed not dead'
]

{ #category : #testing }
MiDeadCodeJavaInitializerHeuristic >> isDead: aTMethod [

	^(aTMethod name = '<Initializer>') not

]

{ #category : #accessing }
MiDeadCodeJavaInitializerHeuristic >> name [

	^super name , 'Initialization block'
]
