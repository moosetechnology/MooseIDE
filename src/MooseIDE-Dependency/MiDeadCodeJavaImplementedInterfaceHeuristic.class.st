Class {
	#name : #MiDeadCodeJavaImplementedInterfaceHeuristic,
	#superclass : #MiDeadCodeAbstractHeuristic,
	#category : #'MooseIDE-Dependency-DeadCode'
}

{ #category : #accessing }
MiDeadCodeJavaImplementedInterfaceHeuristic >> description [

	^'A method implementing a Java interface that is called is not dead
[Refute a method is dead]'
]

{ #category : #testing }
MiDeadCodeJavaImplementedInterfaceHeuristic >> isDead: aTMethod [

	aTMethod parentType interfaceImplementations ifEmpty: [ ^true ].

	aTMethod parentType interfaceImplementations do: [ :interface |
		interface methods do: [ :interfaceMethod |
			((interfaceMethod signature = aTMethod signature) and:
			[ interfaceMethod incomingInvocations isNotEmpty ])
				ifTrue: [ ^false ]
		]
	].

	^true

]

{ #category : #accessing }
MiDeadCodeJavaImplementedInterfaceHeuristic >> name [

	'Implementing Java interface'
]

{ #category : #accessing }
MiDeadCodeJavaImplementedInterfaceHeuristic >> refuteDead [ 

	^true
]
