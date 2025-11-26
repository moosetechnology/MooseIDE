"
An abstract class for all Java heuristics
Adds 'Java:' to the description
"
Class {
	#name : 'MiDeadCodeAbstractPharoHeuristic',
	#superclass : 'MiDeadCodeAbstractHeuristic',
	#category : 'MooseIDE-DeadCode-Rules',
	#package : 'MooseIDE-DeadCode',
	#tag : 'Rules'
}

{ #category : 'accessing' }
MiDeadCodeAbstractPharoHeuristic >> description [

	^super description ,
	'Pharo: '
]

{ #category : 'accessing' }
MiDeadCodeAbstractPharoHeuristic >> name [

	^'Pharo: '
]
