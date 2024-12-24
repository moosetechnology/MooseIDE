Class {
	#name : #MiDeadCodeJavaImplementedInterfaceHeuristic,
	#superclass : #MiDeadCodeAbstractHeuristic,
	#category : #'MooseIDE-Dependency-DeadCode'
}

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

{ #category : #testing }
MiDeadCodeJavaImplementedInterfaceHeuristic >> refuteDead [

	^false
]
