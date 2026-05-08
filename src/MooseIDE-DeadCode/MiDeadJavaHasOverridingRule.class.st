"
A method having an ""@Override"" sub-method (in a subclass) is assumed not-dead,
because one cannot remove the overriden method
(@Override makes it mandatory to have a super-method)
"
Class {
	#name : 'MiDeadJavaHasOverridingRule',
	#superclass : 'MiDeadAbstractJavaRule',
	#category : 'MooseIDE-DeadCode-Rules',
	#package : 'MooseIDE-DeadCode',
	#tag : 'Rules'
}

{ #category : 'testing' }
MiDeadJavaHasOverridingRule >> any: tWithMethods hasOverrideMethod: aTMethod [

	^tWithMethods anySatisfy: [ :aTWithMethods |
		self container: aTWithMethods hasOverrideMethod: aTMethod
	]
]

{ #category : 'testing' }
MiDeadJavaHasOverridingRule >> container: aTWithMethods hasOverrideMethod: aTMethod [

	^aTWithMethods methods
		anySatisfy: [ :mth |
			(mth signature = aTMethod signature) and:
			[ self hasOverrideAnnotation: mth ]
	]
]

{ #category : 'testing' }
MiDeadJavaHasOverridingRule >> hasOverrideAnnotation: anEntity [
	"anEntity has explicit @Override annotation or it implements an interface method
	 ('implicit' @override)"

	^anEntity annotationInstances anySatisfy: [ :anno |
		anno annotationType mooseName = 'java.lang.Override'
	]
]

{ #category : 'accessing' }
MiDeadJavaHasOverridingRule >> name [

	^super name , 'Has @Overriding sub-method'
]

{ #category : 'testing' }
MiDeadJavaHasOverridingRule >> notDead: aTMethod [

	
	| possibleImplementors |
	possibleImplementors := aTMethod parentType isClass
		ifTrue: [ aTMethod parentType subclassHierarchy ]
		ifFalse: [ aTMethod parentType isInterface
			ifTrue: [ self implementingClassHierarchy: aTMethod parentType ]
			ifFalse: [ { aTMethod parentType } ] ].

	^self 	any: possibleImplementors hasOverrideMethod: aTMethod
]
