Extension { #name : 'FamixJavaInterface' }

{ #category : '*MooseIDE-DeadCode' }
FamixJavaInterface >> declaresMethod: aTMethod [

	^self methods anySatisfy: [ :mth | mth signature = aTMethod signature ]
]
