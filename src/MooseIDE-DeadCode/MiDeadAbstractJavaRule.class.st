"
An abstract class for all Java heuristics
Adds 'Java:' to the description
"
Class {
	#name : 'MiDeadAbstractJavaRule',
	#superclass : 'MiDeadAbstractRule',
	#category : 'MooseIDE-DeadCode-Rules',
	#package : 'MooseIDE-DeadCode',
	#tag : 'Rules'
}

{ #category : 'accessing' }
MiDeadAbstractJavaRule class >> heuristicGroups [

	^#( Java ) , super heuristicGroups
]

{ #category : 'accessing' }
MiDeadAbstractJavaRule >> description [

	^super description ,
	'Java: '
]

{ #category : 'testing' }
MiDeadAbstractJavaRule >> implementedInterfaceHierarchy: aType [
	"aTCanImplement can be a TClass or a TInterface.
	 Need to differentiate them"

	^(self isInterface: aType)
		ifTrue: [ { aType } , (aType superclassHierarchy) ]
		ifFalse: [ aType directImplementedInterfaces flatCollectAsSet: [:interface |
			self implementedInterfaceHierarchy: interface ]
		]
]

{ #category : 'testing' }
MiDeadAbstractJavaRule >> isInterface: aType [

	^aType mooseDescription allProperties
		noneSatisfy: [ :fmProp | fmProp name = #interfaceImplementations ].
]

{ #category : 'accessing' }
MiDeadAbstractJavaRule >> name [

	^'Java: '
]

{ #category : 'accessing' }
MiDeadAbstractJavaRule >> ruleGroup [

	^#Java
]
