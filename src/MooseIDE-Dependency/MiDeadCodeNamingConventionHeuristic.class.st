Class {
	#name : #MiDeadCodeNamingConventionHeuristic,
	#superclass : #MiDeadCodeAbstractHeuristic,
	#category : #'MooseIDE-Dependency-DeadCode'
}

{ #category : #testing }
MiDeadCodeNamingConventionHeuristic >> isDead: aTMethod [

	(aTMethod name beginsWith: #test) ifFalse: [ ^false ].
	(aTMethod parentType name endsWith: 'Test') ifFalse: [ ^false ].
	(aTMethod name size > 5)  ifFalse: [ ^false ].
	(aTMethod name fifth isLowercase) ifTrue: [ ^false ].
	^true
]
