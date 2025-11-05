"
An abstract class for all Java heuristics
Adds 'Java:' to the description
"
Class {
	#name : 'MiDeadCodeAbstractJavaHeuristic',
	#superclass : 'MiDeadCodeAbstractHeuristic',
	#category : 'MooseIDE-DeadCode-Rules',
	#package : 'MooseIDE-DeadCode',
	#tag : 'Rules'
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
