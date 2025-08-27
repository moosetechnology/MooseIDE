"
An abstract class for all Java heuristics
Adds 'Java:' to the description
"
Class {
	#name : 'MiDeadCodeAbstractJavaHeuristic',
	#superclass : 'MiDeadCodeAbstractHeuristic',
	#category : 'MooseIDE-Dependency-DeadCode',
	#package : 'MooseIDE-Dependency',
	#tag : 'DeadCode'
}

{ #category : 'accessing' }
MiDeadCodeAbstractJavaHeuristic >> description [

	^super description ,
	'Java: '
]

{ #category : 'accessing' }
MiDeadCodeAbstractJavaHeuristic >> name [

	^'Java: '
]
