"
A heuristic to recognize test methods in Pharo.
(they belong to a clas sinheriting from `TestCase`
"
Class {
	#name : 'MiDeadCodePharoInitializeHeuristic',
	#superclass : 'MiDeadCodeAbstractPharoHeuristic',
	#category : 'MooseIDE-DeadCode-Rules',
	#package : 'MooseIDE-DeadCode',
	#tag : 'Rules'
}

{ #category : 'accessing' }
MiDeadCodePharoInitializeHeuristic >> description [

	^super description ,
	'"Initialize" is constructor, called by "new", therefore not-dead'
]

{ #category : 'accessing' }
MiDeadCodePharoInitializeHeuristic >> name [

	^super name , '"Initialize" method'
]

{ #category : 'testing' }
MiDeadCodePharoInitializeHeuristic >> notDead: aTMethod [

	^aTMethod name = 'initialize'
]
