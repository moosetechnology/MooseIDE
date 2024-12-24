Class {
	#name : #MiDeadCodePharoSuperClassHeuristic,
	#superclass : #MiDeadCodeAbstractHeuristic,
	#category : #'MooseIDE-Dependency-DeadCode'
}

{ #category : #testing }
MiDeadCodePharoSuperClassHeuristic >> isDead: aTMethod [

	^aTMethod parentType superclassHierarchy anySatisfy: [ :c | c name = 'TestCase' ] 
]
