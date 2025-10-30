"
A heuristic to recognize test methods in Pharo.
(they belong to a clas sinheriting from `TestCase`
"
Class {
	#name : 'MiDeadCodePharoTestCaseSubClassHeuristic',
	#superclass : 'MiDeadCodeAbstractTestHeuristic',
	#category : 'MooseIDE-DeadCode',
	#package : 'MooseIDE-DeadCode'
}

{ #category : 'accessing' }
MiDeadCodePharoTestCaseSubClassHeuristic >> description [

	^super description ,
	'In Pharo, sub-classes of TestCase are test classes'
]

{ #category : 'accessing' }
MiDeadCodePharoTestCaseSubClassHeuristic >> name [

	^super name , 'Pharo TestCase sub-class'
]

{ #category : 'testing' }
MiDeadCodePharoTestCaseSubClassHeuristic >> notDead: aTMethod [

	^aTMethod parentType superclassHierarchy
		anySatisfy: [ :c | c name = 'TestCase' ] 
]
