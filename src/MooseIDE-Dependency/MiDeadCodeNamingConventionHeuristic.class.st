Class {
	#name : #MiDeadCodeNamingConventionHeuristic,
	#superclass : #MiDeadCodeAbstractTestHeuristic,
	#category : #'MooseIDE-Dependency-DeadCode'
}

{ #category : #accessing }
MiDeadCodeNamingConventionHeuristic >> description [

	^super description , '
	Check test methods according to naming convention:
	- method name begins with "test"
	- class name ends with "Test"
	- method name is longer than 5 characters ("test...")
	- fifth character is not a lower case ("tester")'
]

{ #category : #testing }
MiDeadCodeNamingConventionHeuristic >> isDead: aTMethod [

	(aTMethod name beginsWith: #test) ifFalse: [ ^false ].
	(aTMethod parentType name endsWith: 'Test') ifFalse: [ ^false ].
	(aTMethod name size > 5)  ifFalse: [ ^false ].
	(aTMethod name fifth isLowercase) ifTrue: [ ^false ].
	^true
]

{ #category : #accessing }
MiDeadCodeNamingConventionHeuristic >> name [

	^'Test: Naming convention'
]
