"
An abstract class for 'test methods' heurisitcs

All  methods of a test class are considered not dead
There are several heuristics to check if a method is a ""test method""

All these heuristics are refuting that a method is dead, meaning:
- when they are true, the method is considered Not Dead
- when they are false, it is undecided
"
Class {
	#name : #MiDeadCodeAbstractTestHeuristic,
	#superclass : #MiDeadCodeAbstractHeuristic,
	#category : #'MooseIDE-Dependency-DeadCode'
}

{ #category : #accessing }
MiDeadCodeAbstractTestHeuristic >> description [ 

	^super description ,
	'Any method of a test class is considered not dead'
]

{ #category : #accessing }
MiDeadCodeAbstractTestHeuristic >> name [

	^super name , 'Test: '
]
