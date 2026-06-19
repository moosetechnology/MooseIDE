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

{ #category : 'testing' }
MiDeadJavaInitializerRule >> isEnumConstructor: aTMethod [
	"For simplification, we assume enum constructors are always called.
	 VerveineJ currently does not model that correctly"

	^(aTMethod parentType class = FamixJavaEnum) and: [
		aTMethod isConstructor ]
]

{ #category : 'accessing' }
MiDeadJavaInitializerRule >> name [

	^super name , 'Default constructor/Initialization block'
]

{ #category : 'testing' }
MiDeadJavaInitializerRule >> notDead: aTMethod [

	^(aTMethod name = '<Initializer>') or:
	[  (aTMethod isDefaultConstructor)  or:
	[  self isEnumConstructor: aTMethod ] ]

]
