"
A heuristic to recognize test methods based on naming conventions.
See #description for details
"
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

	(aTMethod name beginsWith: #test) ifFalse: [ ^true ].
	(aTMethod parentType name endsWith: 'Test') ifFalse: [ ^true ].
	(aTMethod name size > 5)  ifFalse: [ ^true ].
	(aTMethod name fifth isLowercase) ifTrue: [ ^true ].
	^false
]

{ #category : #accessing }
MiDeadCodeNamingConventionHeuristic >> name [

	^'Test: Naming convention'
]
