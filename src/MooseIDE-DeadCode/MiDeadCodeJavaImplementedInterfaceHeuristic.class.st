"
A heuristic to recognize methods implementing a Java interface method that is called.

I a Java interface method is called, we assume any method implementing it in a concrete class can be called
"
Class {
	#name : 'MiDeadCodeJavaImplementedInterfaceHeuristic',
	#superclass : 'MiDeadCodeAbstractJavaHeuristic',
	#category : 'MooseIDE-DeadCode-Rules',
	#package : 'MooseIDE-DeadCode',
	#tag : 'Rules'
}

{ #category : 'accessing' }
MiDeadCodeJavaImplementedInterfaceHeuristic >> description [

	^super description ,
	'All methods overriding an invoked method are assumed not-dead'
]

{ #category : 'testing' }
MiDeadCodeJavaImplementedInterfaceHeuristic >> implementsInterfaceMethods: aTMethod [
	"aTMethod implements methods declared in Java interfaces"

	(aTMethod parentType mooseDescription allProperties
		noneSatisfy: [ :fmProp | fmProp name = #interfaceImplementations ]) ifTrue: [ ^#() ].

	aTMethod parentType interfaceImplementations ifEmpty: [ ^#() ].

	^aTMethod parentType interfaceImplementations
		flatCollect: [ :implementation |
			implementation interface methods
				select: [ :interfaceMethod | interfaceMethod signature = aTMethod signature]
		].

]

{ #category : 'accessing' }
MiDeadCodeJavaImplementedInterfaceHeuristic >> name [

	^super name , 'Overriden invoked method'
]

{ #category : 'testing' }
MiDeadCodeJavaImplementedInterfaceHeuristic >> notDead: aTMethod [

	(self implementsInterfaceMethods: aTMethod)
		do: [ :interfaceMethod |
			interfaceMethod incomingInvocations isNotEmpty ifTrue: [ ^true ]
		].

	(self overridesMethods: aTMethod)
		do: [ :overridenMethod |
			overridenMethod incomingInvocations isNotEmpty ifTrue: [ ^true ]
		].

	^ false
]

{ #category : 'testing' }
MiDeadCodeJavaImplementedInterfaceHeuristic >> overridesMethods: aTMethod [
	"aTMethod overridess methods defines in Java superclasses"

	^aTMethod parentType superclassHierarchy
		flatCollect: [ :superclass |
			superclass methods
				select: [ :overridenMethod | overridenMethod signature = aTMethod signature]
		].

]
