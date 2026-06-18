Extension { #name : 'FamixJavaInterface' }

{ #category : '*MooseIDE-DeadCode' }
FamixJavaInterface >> declaresMethod: aTMethod [

	^self methods anySatisfy: [ :mth | aTMethod signatureMatch: mth ]
]
