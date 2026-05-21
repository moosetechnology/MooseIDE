Extension { #name : 'FamixJavaParametricInterface' }

{ #category : '*MooseIDE-DeadCode' }
FamixJavaParametricInterface >> declaresMethod: aTMethod [
	"simplification: the signatures do not match because one typically uses ParameterTypes and the other ArgumentTypes"

	^self methods anySatisfy: [ :mth | mth name = aTMethod name ]
]
