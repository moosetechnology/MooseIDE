"
An abstract class for all Java heuristics
Adds 'Java:' to the description
"
Class {
	#name : 'MiDeadCodeAbstractJavaHeuristic',
	#superclass : 'MiDeadCodeAbstractHeuristic',
	#category : 'MooseIDE-DeadCode-Rules',
	#package : 'MooseIDE-DeadCode',
	#tag : 'Rules'
}

{ #category : 'accessing' }
MiDeadCodeAbstractJavaHeuristic >> description [

	^super description ,
	'Java: '
]

{ #category : 'testing' }
MiDeadCodeAbstractJavaHeuristic >> implementedInterfaceHierarchy: aType [
	"aTCanImplement can be a TClass or a TInterface.
	 Need to differentiate them"

	^(self isInterface: aType)
		ifTrue: [ { aType } , (aType superclassHierarchy) ]
		ifFalse: [ aType directImplementedInterfaces flatCollectAsSet: [:interface |
			self implementedInterfaceHierarchy: interface ]
		]
]

{ #category : 'testing' }
MiDeadCodeAbstractJavaHeuristic >> isInterface: aType [

	^aType mooseDescription allProperties
		noneSatisfy: [ :fmProp | fmProp name = #interfaceImplementations ].
]

{ #category : 'accessing' }
MiDeadCodeAbstractJavaHeuristic >> name [

	^'Java: '
]
