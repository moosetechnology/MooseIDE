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
