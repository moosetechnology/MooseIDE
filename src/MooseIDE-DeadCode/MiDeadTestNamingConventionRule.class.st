"
A heuristic to recognize test methods based on naming conventions.
See #description for details
"
Class {
	#name : 'MiDeadTestNamingConventionRule',
	#superclass : 'MiDeadAbstractRule',
	#category : 'MooseIDE-DeadCode-Rules',
	#package : 'MooseIDE-DeadCode',
	#tag : 'Rules'
}

{ #category : 'accessing' }
MiDeadTestNamingConventionRule >> description [

	^super description ,
	'Any method of a test class is assumed not-dead.
	Check test methods according to naming convention:
	- method name begins with "test"
	- class name ends with "Test"
	- method name is longer than 5 characters ("test...")
	- 5th character is not a lower case (eg. not "tester")'
]

{ #category : 'accessing' }
MiDeadTestNamingConventionRule >> name [

	^super name , 'Naming convention'
]

{ #category : 'testing' }
MiDeadTestNamingConventionRule >> notDead: aTMethod [

	(aTMethod name beginsWith: #test) ifFalse: [ ^false ].
	(aTMethod parentType name endsWith: 'Test') ifFalse: [ ^false ].
	(aTMethod name size > 5)  ifFalse: [ ^false ].
	(aTMethod name fifth isLowercase) ifTrue: [ ^false ].
	^true
]
