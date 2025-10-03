Class {
	#name : 'MiDeadCodeJavaInitializerHeuristic',
	#superclass : 'MiDeadCodeAbstractJavaHeuristic',
	#category : 'MooseIDE-Dependency-DeadCode',
	#package : 'MooseIDE-Dependency',
	#tag : 'DeadCode'
}

{ #category : 'accessing' }
MiDeadCodeJavaInitializerHeuristic >> description [

	^super description ,
	'Initialization block in Java are assumed not dead'
]

{ #category : 'accessing' }
MiDeadCodeJavaInitializerHeuristic >> name [

	^super name , 'Initialization block'
]

{ #category : 'testing' }
MiDeadCodeJavaInitializerHeuristic >> notDead: aTMethod [

	^aTMethod name = '<Initializer>'

]
