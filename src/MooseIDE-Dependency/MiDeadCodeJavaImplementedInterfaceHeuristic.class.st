"
A heuristic to recognize methods implementing a Java interface method that is called.

I a Java interface method is called, we assume any method implementing it in a concrete class can be called
"
Class {
	#name : #MiDeadCodeJavaImplementedInterfaceHeuristic,
	#superclass : #MiDeadCodeAbstractJavaHeuristic,
	#category : #'MooseIDE-Dependency-DeadCode'
}

{ #category : #accessing }
MiDeadCodeJavaImplementedInterfaceHeuristic >> description [

	^super description ,
	'A method implementing a Java interface that is called is not dead'
]

{ #category : #testing }
MiDeadCodeJavaImplementedInterfaceHeuristic >> isDead: aTMethod [
	"metods implementing a Java interface method that is invoked are considered not dead
	 the other one are 'dead' (refuting heuristic)"

	(aTMethod parentType mooseDescription allProperties noneSatisfy: [ :fmProp |
		fmProp name = #interfaceImplementations ])
		ifTrue: [ ^true ].

	aTMethod parentType interfaceImplementations ifEmpty: [ ^true ].

	aTMethod parentType interfaceImplementations do: [ :implementation |
		implementation interface methods
			detect: [ :interfaceMethod |
				(interfaceMethod signature = aTMethod signature) and:
				[ interfaceMethod incomingInvocations isNotEmpty ] ]
			ifOne: [ :ignore | ^false ]
		].

	^true

]

{ #category : #accessing }
MiDeadCodeJavaImplementedInterfaceHeuristic >> name [

	^super name , 'Implemented interface'
]
