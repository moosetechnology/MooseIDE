"
In Java, the default constructor is invoked by any other constructor, and the initialization block is invoked by all constructors.

So if any of the other constructors is not dead, then these ones are not-dead either.
But rules cannot model this, so we just assume they are not-dead by default
"
Class {
	#name : 'MiDeadCodeJavaInitializerHeuristic',
	#superclass : 'MiDeadCodeAbstractJavaHeuristic',
	#category : 'MooseIDE-DeadCode-Rules',
	#package : 'MooseIDE-DeadCode',
	#tag : 'Rules'
}

{ #category : 'visiting' }
MiDeadCodeJavaInitializerHeuristic >> accept: aTMethod [

	^self notDead: aTMethod 
]

{ #category : 'testing' }
MiDeadCodeJavaInitializerHeuristic >> classHasNonDefaultConstructor: aClass [

	aClass methods
		detect: [ :m | m isConstructor and: [ m parameters isNotEmpty ] ]
		ifOne: [ :nonDefaultConstructor | ^true ]
		ifNone: [ ^false ]

]

{ #category : 'accessing' }
MiDeadCodeJavaInitializerHeuristic >> description [

	^super description ,
	'Default constructor and initialization block are assumed not-dead'
]

{ #category : 'testing' }
MiDeadCodeJavaInitializerHeuristic >> isDefaultConstructorWithOtherConstructors: aTMethod [
	"the default constructor (no parameter) is always called by any other constructor
	 Note: assumes but does not check that the other constructor is itself called"

	aTMethod isConstructor ifFalse: [ ^false ].
	aTMethod parameters isEmpty ifFalse: [ ^false ].
	^self classHasNonDefaultConstructor: aTMethod parentType

]

{ #category : 'accessing' }
MiDeadCodeJavaInitializerHeuristic >> isForEntryPoint [

	^true
]

{ #category : 'testing' }
MiDeadCodeJavaInitializerHeuristic >> isInitializerBlock: aTMethod [

	^aTMethod name = '<Initializer>'
]

{ #category : 'accessing' }
MiDeadCodeJavaInitializerHeuristic >> name [

	^super name , 'Defautl constructor/Initialization block'
]

{ #category : 'testing' }
MiDeadCodeJavaInitializerHeuristic >> notDead: aTMethod [

	| parentType |
	parentType := aTMethod parentType.

	^(self isInitializerBlock: aTMethod ) or:
	[  self isDefaultConstructorWithOtherConstructors: aTMethod ]
	"[ (aTMethod name = parentType name) and:
		[ (aTMethod parameters isEmpty) and: 
		 [parentType methods count: [ :m | m name = aTMethod parentType name ]] ]]
"
]
