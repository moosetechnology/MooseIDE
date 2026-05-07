"
In Java, the default constructor is invoked by any other constructor, and the initialization block is invoked by all constructors.

So if any of the other constructors is not dead, then these ones are not-dead either.
But rules cannot model this, so we just assume they are not-dead by default
"
Class {
	#name : 'MiDeadJavaInitializerRule',
	#superclass : 'MiDeadAbstractJavaRule',
	#category : 'MooseIDE-DeadCode-Rules',
	#package : 'MooseIDE-DeadCode',
	#tag : 'Rules'
}

{ #category : 'visiting' }
MiDeadJavaInitializerRule >> accept: aTMethod [

	^self notDead: aTMethod 
]

{ #category : 'testing' }
MiDeadJavaInitializerRule >> classHasNonDefaultConstructor: aClass [

	aClass methods
		detect: [ :m | m isConstructor and: [ m parameters isNotEmpty ] ]
		ifOne: [ :nonDefaultConstructor | ^true ]
		ifNone: [ ^false ]

]

{ #category : 'testing' }
MiDeadJavaInitializerRule >> isDefaultConstructor: aTMethod [
	"the default constructor (no parameter) is always called"

	aTMethod isConstructor ifFalse: [ ^false ].
	aTMethod parameters ifNotEmpty: [ ^false ].

	^true

]

{ #category : 'testing' }
MiDeadJavaInitializerRule >> isEnumConstructor: aTMethod [
	"For simplification, we assume enum constructors are always called.
	 VerveineJ currently does not model that correctly"

	^(aTMethod parentType class = FamixJavaEnum) and: [
		aTMethod isConstructor ]
]

{ #category : 'accessing' }
MiDeadJavaInitializerRule >> isForEntryPoint [

	^true
]

{ #category : 'testing' }
MiDeadJavaInitializerRule >> isInitializerBlock: aTMethod [

	^aTMethod name = '<Initializer>'
]

{ #category : 'accessing' }
MiDeadJavaInitializerRule >> name [

	^super name , 'Defautl constructor/Initialization block'
]

{ #category : 'testing' }
MiDeadJavaInitializerRule >> notDead: aTMethod [

	| parentType |
	parentType := aTMethod parentType.

	^(self isInitializerBlock: aTMethod ) or:
	[  (self isDefaultConstructor: aTMethod)  or:
	[  self isEnumConstructor: aTMethod ] ]

]
