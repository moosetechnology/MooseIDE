Class {
	#name : 'MiDeadCodeJavaHasOverridingHeuristic',
	#superclass : 'MiDeadCodeAbstractJavaHeuristic',
	#category : 'MooseIDE-DeadCode-Rules',
	#package : 'MooseIDE-DeadCode',
	#tag : 'Rules'
}

{ #category : 'testing' }
MiDeadCodeJavaHasOverridingHeuristic >> any: tWithMethods hasOverrideMethod: aTMethod [

	^tWithMethods anySatisfy: [ :aTWithMethods |
		self container: aTWithMethods hasOverrideMethod: aTMethod
	]
]

{ #category : 'testing' }
MiDeadCodeJavaHasOverridingHeuristic >> container: aTWithMethods hasOverrideMethod: aTMethod [

	^aTWithMethods methods
		anySatisfy: [ :mth |
			(mth signature = aTMethod signature) and:
			[ self hasOverrideAnnotation: mth ]
	]
]

{ #category : 'accessing' }
MiDeadCodeJavaHasOverridingHeuristic >> description [

	^super description ,
		'A method having an "@Overriding" method (in a subclass) is assumed not-dead
		 Because one cannot remove the overriden method'
]

{ #category : 'testing' }
MiDeadCodeJavaHasOverridingHeuristic >> hasOverrideAnnotation: anEntity [

	^anEntity annotationInstances anySatisfy: [ :anno |
		anno annotationType mooseName = 'java.lang.Override'
	]
]

{ #category : 'accessing' }
MiDeadCodeJavaHasOverridingHeuristic >> name [

	^super name , 'Has @Overriding sub-method'
]

{ #category : 'testing' }
MiDeadCodeJavaHasOverridingHeuristic >> notDead: aTMethod [

	^self
		any: aTMethod parentType subclassHierarchy
		hasOverrideMethod: aTMethod
]
