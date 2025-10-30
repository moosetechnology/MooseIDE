"
A heuristic to recognize test methods based on naming conventions.
See #description for details
"
Class {
	#name : 'MiDeadCodeNamingConventionHeuristic',
	#superclass : 'MiDeadCodeAbstractTestHeuristic',
	#category : 'MooseIDE-DeadCode',
	#package : 'MooseIDE-DeadCode'
}

{ #category : 'accessing' }
MiDeadCodeNamingConventionHeuristic >> description [

	^super description ,
	'Check test methods according to naming convention:
	- method name begins with "test"
	- class name ends with "Test"
	- method name is longer than 5 characters ("test...")
	- 5th character is not a lower case (eg. not "tester")'
]

{ #category : 'accessing' }
MiDeadCodeNamingConventionHeuristic >> name [

	^super name , 'Naming convention'
]

{ #category : 'testing' }
MiDeadCodeNamingConventionHeuristic >> notDead: aTMethod [

	(aTMethod name beginsWith: #test) ifFalse: [ ^false ].
	(aTMethod parentType name endsWith: 'Test') ifFalse: [ ^false ].
	(aTMethod name size > 5)  ifFalse: [ ^false ].
	(aTMethod name fifth isLowercase) ifTrue: [ ^false ].
	^true
]
