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

{ #category : 'as yet unclassified' }
MiDeadAbstractJavaRule >> allImplementingClasses: anInterface [

	^anInterface implementations flatCollect: [ :imp |
		{imp implementingClass}  , (imp implementingClass subclassHierarchy) ]
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

{ #category : 'as yet unclassified' }
MiDeadAbstractJavaRule >> implementingClassHierarchy: anInterface [

	| intrfHierarchy |
	intrfHierarchy := {  anInterface } , (self subInterfaceHierarchy: anInterface).
	^(intrfHierarchy
		flatCollect: [ :intrfc | self allImplementingClasses: intrfc ])
		asOrderedCollection removeDuplicates 
]

{ #category : 'testing' }
MiDeadAbstractJavaRule >> isInterface: aType [

	^ aType allDeclaredProperties noneSatisfy: [ :fmProp | fmProp name = #interfaceImplementations ]
]

{ #category : 'accessing' }
MiDeadAbstractJavaRule >> name [

	^'Java: '
]

{ #category : 'accessing' }
MiDeadAbstractJavaRule >> ruleGroup [

	^#Java
]

{ #category : 'as yet unclassified' }
MiDeadAbstractJavaRule >> subInterfaceHierarchy: anInterface [
	"#allSubclassesDo: on interfaces may can only return a collection of (sub-)interfaces"

	| subinterfaces |

	subinterfaces := OrderedCollection new.
	anInterface allSubclassesDo: [:each | subinterfaces add: each].

	^ subinterfaces
]
