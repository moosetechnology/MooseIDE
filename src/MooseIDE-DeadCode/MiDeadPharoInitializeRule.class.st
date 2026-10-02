"
A heuristic to recognize test methods in Pharo.
(they belong to a clas sinheriting from `TestCase`
"
Class {
	#name : #MiDeadPharoInitializeRule,
	#superclass : #MiDeadAbstractPharoRule,
	#category : #'MooseIDE-DeadCode-Rules'
}

{ #category : #accessing }
MiDeadPharoInitializeRule >> name [

	^super name , '"Initialize" method'
]

{ #category : #testing }
MiDeadPharoInitializeRule >> notDead: aTMethod [

	^aTMethod name = 'initialize'
]
