"
A heuristic to recognize test methods in Pharo.
(they belong to a clas sinheriting from `TestCase`
"
Class {
	#name : 'MiDeadPharoTestCaseSubClassRule',
	#superclass : 'MiDeadAbstractPharoRule',
	#category : 'MooseIDE-DeadCode-Rules',
	#package : 'MooseIDE-DeadCode',
	#tag : 'Rules'
}

{ #category : 'accessing' }
MiDeadPharoTestCaseSubClassRule >> description [

	^super description ,
	'Sub-classes of TestCase are test classes'
]

{ #category : 'accessing' }
MiDeadPharoTestCaseSubClassRule >> name [

	^super name , 'TestCase sub-class'
]

{ #category : 'testing' }
MiDeadPharoTestCaseSubClassRule >> notDead: aTMethod [

	^aTMethod parentType superclassHierarchy
		anySatisfy: [ :c | c name = 'TestCase' ] 
]
