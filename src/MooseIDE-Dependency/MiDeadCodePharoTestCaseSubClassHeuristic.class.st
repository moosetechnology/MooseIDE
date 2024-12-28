"
A heuristic to recognize test methods in Pharo.
(they belong to a clas sinheriting from `TestCase`
"
Class {
	#name : #MiDeadCodePharoTestCaseSubClassHeuristic,
	#superclass : #MiDeadCodeAbstractTestHeuristic,
	#category : #'MooseIDE-Dependency-DeadCode'
}

{ #category : #accessing }
MiDeadCodePharoTestCaseSubClassHeuristic >> description [

	^super description , '
	In Pharo, sub-classes of TestCase are test classes'
]

{ #category : #testing }
MiDeadCodePharoTestCaseSubClassHeuristic >> isDead: aTMethod [

	^aTMethod parentType superclassHierarchy noneSatisfy: [ :c | c name = 'TestCase' ] 
]

{ #category : #accessing }
MiDeadCodePharoTestCaseSubClassHeuristic >> name [

	^super name , 'TestCase sub-class'
]
